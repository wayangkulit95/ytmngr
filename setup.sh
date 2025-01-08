#!/bin/bash

# Update and upgrade system packages
echo "Updating system..."
sudo apt-get update && sudo apt-get upgrade -y

# Install Node.js and npm
echo "Installing Node.js and npm..."
curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install sqlite3 (for database)
echo "Installing SQLite3..."
sudo apt-get install -y sqlite3

# Install yt-dlp (video downloading tool)
echo "Installing yt-dlp..."
sudo apt-get install -y yt-dlp

# Install FFmpeg (for video processing)
echo "Installing FFmpeg..."
sudo apt-get install -y ffmpeg

# Install necessary Node.js packages (express, sqlite3)
echo "Installing Node.js dependencies..."
npm init -y
npm install express sqlite3

# Create necessary directories for streaming
echo "Creating necessary directories..."
mkdir -p streams

# Create a basic cookies.txt file (You can modify this later for your YouTube authentication if needed)
echo "Creating a sample cookies.txt file..."
touch cookies.txt

# Create the stream.js file with the provided code
echo "Creating stream.js..."
cat > stream.js << 'EOF'
const express = require('express');
const { exec } = require('child_process');
const path = require('path');
const fs = require('fs');
const sqlite3 = require('sqlite3').verbose(); // Import SQLite3

const app = express();
const PORT = 80; // Change to port 80
const streams = {}; // Store stream information

const db = new sqlite3.Database('./streams.db', (err) => {
    if (err) {
        console.error('Error opening database:', err.message);
    } else {
        // Create table if not exists
        db.run(`
            CREATE TABLE IF NOT EXISTS streams (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                videoId TEXT UNIQUE
            );
        `);
    }
});

app.use(express.urlencoded({ extended: true }));

// Serve static files
app.use('/streams', express.static('streams'));

// Render the index page
app.get('/', (req, res) => {
    db.all('SELECT * FROM streams', (err, rows) => {
        if (err) {
            console.error(err.message);
            return res.status(500).send('Error retrieving streams.');
        }

        res.send(`
            <h1>YouTube Streamer</h1>
            <form action="/add-stream" method="POST">
                <input type="text" name="videoId" placeholder="YouTube Video ID" required>
                <button type="submit">Add Stream</button>
            </form>
            <h2>Active Streams</h2>
            <ul>
                ${rows.map(row => `
                    <li>
                        ${row.videoId}
                        <button onclick="removeStream('${row.videoId}')">Remove</button>
                        <br>
                        <a href="http://${req.headers.host}/streams/stream_${row.videoId}/stream.m3u8">M3U8 Link</a>
                    </li>
                `).join('')}
            </ul>
            <script>
                function removeStream(videoId) {
                    fetch('/remove-stream', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify({ videoId })
                    }).then(() => location.reload());
                }
            </script>
        `);
    });
});

// Add a new stream
app.post('/add-stream', (req, res) => {
    const videoId = req.body.videoId;
    const streamName = `stream_${videoId}`; // Create a unique stream name
    const m3u8File = path.join(__dirname, 'streams', `${streamName}`, 'stream.m3u8');

    // Insert videoId into database
    db.run('INSERT OR IGNORE INTO streams (videoId) VALUES (?)', [videoId], (err) => {
        if (err) {
            console.error('Error inserting videoId:', err.message);
            return res.status(500).send('Error saving video ID.');
        }

        if (!fs.existsSync(path.join(__dirname, 'streams', streamName))) {
            fs.mkdirSync(path.join(__dirname, 'streams', streamName), { recursive: true });
        }

        const ffmpegProcess = exec(`yt-dlp --cookies cookies.txt -f b -g "https://www.youtube.com/watch?v=${videoId}"`, (error, stdout, stderr) => {
            if (error) {
                console.error(`Error fetching stream URL: ${error.message}`);
                return res.status(500).send('Error fetching stream URL.');
            }
            const streamUrl = stdout.trim();
            if (!streamUrl) {
                console.error('Stream URL is empty.');
                return res.status(500).send('Error: Stream URL is empty.');
            }

            // Adjusted FFmpeg command to retain only the latest 10 segments
            const ffmpegCommand = `ffmpeg -re -i "${streamUrl}" -c:v copy -c:a copy -f hls -hls_time 20 -hls_list_size 20 -hls_flags delete_segments "${m3u8File}"`;

            const ffmpegProcess = exec(ffmpegCommand, (error) => {
                if (error) {
                    console.error(`FFmpeg error: ${error.message}`);
                } else {
                    console.log(`Streaming started for ${streamName}`);
                }
            });

            streams[streamName] = ffmpegProcess; // Store the process
            res.redirect('/');
        });
    });
});

// Remove a stream
app.post('/remove-stream', (req, res) => {
    const videoId = req.body.videoId;
    const streamName = `stream_${videoId}`;
    const streamPath = path.join(__dirname, 'streams', streamName);

    // Delete from database
    db.run('DELETE FROM streams WHERE videoId = ?', [videoId], (err) => {
        if (err) {
            console.error('Error deleting videoId:', err.message);
            return res.status(500).send('Error removing stream.');
        }

        if (streams[streamName]) {
            streams[streamName].kill(); // Kill the ffmpeg process
            delete streams[streamName]; // Remove from active streams
        }

        if (fs.existsSync(streamPath)) {
            fs.rmdirSync(streamPath, { recursive: true }); // Remove stream directory
        }

        res.sendStatus(200);
    });
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
EOF

# Final message
echo "Setup complete. You can now run the server using: node stream.js"
