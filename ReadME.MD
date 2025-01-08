# YouTube Streamer - Live Streaming with FFmpeg and yt-dlp

This project allows you to stream YouTube videos using **yt-dlp** and **FFmpeg**, generating **M3U8** streams that can be played in a media player or web browser.

## Features
- Add YouTube video streams by providing a YouTube Video ID.
- Stream live video with FFmpeg.
- Delete active streams from the interface.
- Create dynamic M3U8 stream links.

## Requirements

- **Node.js** (Version 16 or higher)
- **yt-dlp** (for downloading YouTube videos)
- **FFmpeg** (for handling live streams)
- **SQLite3** (for storing stream data)

## Installation

Follow these steps to install and set up the project.



## Installation
  ```
  curl -sL https://raw.githubusercontent.com/wayangkulit95/ytmngr/main/setup.sh -o setup.sh && chmod +x setup.sh && ./setup.sh
  ```



## Installing yt-dlp on Linux (Debian/Ubuntu)
You can easily install yt-dlp using pip, the Python package manager. Alternatively, you can also use a package manager like apt if available.

Method 1: Using pip (recommended)
Install yt-dlp using pip:


  ```
sudo apt update
sudo apt install -y python3-pip
sudo pip3 install -U yt-dlp
  ```



Verify the installation:


  ```
  yt-dlp --version

  ```


