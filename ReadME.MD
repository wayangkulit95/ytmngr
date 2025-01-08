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


## To ensure that your cookies file does not get overwritten or modified by yt-dlp after you manually input the cookies, you'll need to make sure that:


The cookies file is not changed by yt-dlp during usage.
You manually manage the cookies file.
By default, yt-dlp will not modify or update the cookies file unless explicitly instructed to do so (e.g., using options like --cookies-save).

Here are a few strategies to ensure that your cookies remain static and are not overwritten:

## 1. Manual Management of Cookies File
Manually Save Cookies: After you have manually obtained the cookies using a browser tool (such as the method we discussed with Selenium or browser developer tools), do not let yt-dlp modify the cookies.

Use the --cookies option: You can use the cookies file directly in the command without any additional modifications.

Example command:

Copy code
```
yt-dlp --cookies cookies.txt "https://www.youtube.com/watch?v=VIDEO_ID"
```


No Cookie Saving Flag: Ensure you do not use the --cookies-save option when running yt-dlp, as it will save a new cookies file based on the current session and overwrite the existing one.

## 2. Ensure Cookies File is Not Modified
To ensure that the cookies file (cookies.txt) is not overwritten by yt-dlp, avoid commands that may trigger cookie updates.

Use yt-dlp without any saving options:

If you do not want yt-dlp to update or overwrite the cookies file, just use it with the --cookies flag pointing to your cookies file, as shown below:

Copy code
```
yt-dlp --cookies cookies.txt "https://www.youtube.com/watch?v=VIDEO_ID"
```


## 3. Protect the Cookies File
On some systems, you can use file permissions to make the cookies file read-only, preventing accidental changes.

On Linux/macOS:
Set the cookies file as read-only:

Copy code
```
chmod 444 cookies.txt
```


This command makes the cookies.txt file readable but not writable by any user. You can still read from it in yt-dlp, but you cannot accidentally overwrite or modify it without changing the permissions again.

If you need to make changes to the cookies file in the future, you can change the permissions back to writable:

Copy code
```
chmod 644 cookies.txt
```


On Windows:
Right-click on cookies.txt → Properties → under the General tab, check the box next to Read-only.
This ensures that the file is protected from being overwritten accidentally by the tool.

## 4. Prevent Cookie Update within yt-dlp (Using a Script)
If you are running yt-dlp within a script and want to ensure that cookies are not updated, you can simply avoid using any flags that could change the cookies file.

For example:

Copy code
```
#!/bin/bash
# Don't update or save cookies; only use the static cookies file
```

yt-dlp --cookies cookies.txt "https://www.youtube.com/watch?v=VIDEO_ID"
This way, even if the script is used repeatedly, it will always use the static cookies file without trying to update it.

## Summary
No automatic cookies modification: By simply using the --cookies cookies.txt option and avoiding the --cookies-save flag, yt-dlp will not overwrite or modify the cookies file.
File protection: Use file permissions (on Linux or macOS) or read-only properties (on Windows) to ensure that the cookies file remains unchanged.
Static cookies: Only update the cookies manually when necessary, and use the same cookies file throughout your interactions.
This way, you ensure that your cookies file remains static and does not get overwritten after each use.


