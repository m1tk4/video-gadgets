# video-gadgets
Various scripts and configurations for FFMPEG, TSDuck and other video processing tools.

- [enc_profile](#enc_profile): shortcuts for popular encoding profiles for `ffmpeg`
- [gif_encode](#gif_encode): convert video files to GIF
- [hdbars](#hdbars): send test pattern to a file or streaming destination

## Installation

RPM:
```bash
sudo rpm -ivh \
    https://github.com/m1tk4/video-gadgets/releases/download/v1.2.0/video-gadgets-1.2.0.noarch.rpm
```

DEB:
```bash
curl -sLO \
    https://github.com/m1tk4/video-gadgets/releases/download/v1.2.0/video-gadgets_1.2.0_all.deb \ 
    && sudo dpkg -i video-gadgets_1.2.0_all.deb 
```

Any other Linux:
```bash
cd /; \
sudo curl -L \
    https://github.com/m1tk4/video-gadgets/releases/download/v1.2.0/hdbars \
    | tar xvzf
```

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
## hdbars 
Produces a video test pattern with 

- HD SMPTE Bars, 
- hostname (or custom text header) 
- local time, 
- timecode,
- custom logo (optional), 
- an audible beep every 1 second and 
- an animation with synchronized moving indicator:

![hdbars screenshot](/assets/hdbars-screenshot.gif)
