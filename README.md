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

![hdbars screenshot](/assets/hdbars-screenshot.gif)

## enc_profile
Outputs one of the predefined FFMPEG encoding profiles - for use with FFMPEG transcoding
tasks.

Use in ffmpeg commands:
```bash
ffmpeg -i myfile.mov `enc_profile twitch` -f flv rtpm://twitch.com/something
```

List available profiles:
```bash
$ enc_profile --list
 
Available encoding profiles:
-----------------------------------------------------------------
copy:          Copy (pass-through source)
default:       Default (x264:veryfast/aac@128k)
testpattern:   Test patterns (x264:veryfast/aac@24k)
twitch:        Twitch (x264:veryfast@3M/aac@160k)
wowza:         Wowza (x264:medium@1mbps/aac@128k)
youtube:       Youtube (x264:veryfast@3M/aac@128k)
```

## gif_encode

Scales and encodes a source video file into .GIF, extracting the palette from the source file first.

Sample:
```bash
$ gif_encode --width 640 --fps 10 source.mkv dest.gif
```

## Installation

RPM:
```bash
sudo rpm -ivh https://github.com/m1tk4/video-gadgets/releases/download/v1.1.0/video-gadgets-1.1.0.noarch.rpm
```

Any other Linux:
```bash
cd /; \
sudo curl -L \
    https://github.com/m1tk4/video-gadgets/releases/download/v1.1.0/hdbars \
    | tar xvzf
```
