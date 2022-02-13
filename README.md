# video-gadgets
Various scripts and configurations for FFMPEG, TSDuck and other video processing tools.

## hdbars 
Produces a video test pattern with 

- HD SMPTE Bars, 
- hostname (or custom text header) 
- local time, 
- timecode, 
- an audible beep every 1 second and 
- an animation with synchronized moving indicator:

![hdbars screenshot](/assets/hdbars-screenshot.png)

## Installation

RPM:
```bash
rpm -ivH https://github.com/m1tk4/video-gadgets/releases/download/v1.0.0/video-gadgets-1.0.0.noarch.rpm
```

Any other Linux:
```bash
curl -o /usr/bin/hdbars -L \
    https://github.com/m1tk4/video-gadgets/releases/download/v1.0.0/hdbars; \
chmod a+x /usr/bin/hdbars
```