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

## vgp
Outputs one of the predefined FFMPEG encoding profiles - for use with FFMPEG transcoding
tasks.

Use in ffmpeg commands:
```bash
ffmpeg -i myfile.mov `vgp twitch` -f flv rtpm://twitch.com/something
ffmpeg -i myfile.mov `vgp fullscreen`
```

List available profiles:
```bash
$ vgp --list
 
Available encoding profiles:
-----------------------------------------------------------------
copy:          Copy (pass-through)
default:       Default (x264:veryfast/aac@128k)
fullscreen:    Local screen playback
raw:           Raw
testpattern:   Test patterns (x264:veryfast/aac@24k)
twitch:        Twitch (x264:veryfast@3M/aac@160k)
window:        Local screen playback
wowza:         Wowza (x264:medium@1mbps/aac@128k)
youtube:       Youtube (x264:veryfast@3M/aac@128k)
```

You can add custom profiles by editing / adding the following files:

- `/etc/vg_profile.conf`
- `./vg_profile.conf`
- `./*.vg_profile.conf`
- `~/.vg_profile.conf`

See `vg_profile.conf` for syntax samples.