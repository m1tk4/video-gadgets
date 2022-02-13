#!/bin/bash

#
#   Note: this is a set of common variables and functions used by 
#   video-gadgets. Should only be sourced from other things
#

# Build the list of our encoding profiles
typeset -A vg_profile=(

    # Default video-gadgets profile
    [default]="Default (x264:veryfast/aac@128k)"
    [default.v]="-c:v libx264 -preset veryfast -g 60"
    [default.a]="-c:a aac -ac 2 -ar 44100 -b:a 128k"

    # Copy
    [copy]="Copy (pass-through source)"
    [copy.v]="-c:v copy"
    [copy.a]="-c:a copy"

    # Test pattern - default used in hdbars
    [testpattern]="Test patterns (x264:veryfast/aac@24k)"
    [testpattern.v]="-c:v libx264 -preset veryfast -g 60"
    [testpattern.a]="-c:a aac -ac 2 -ar 44100 -b:a 36k"

    # Twitch - see https://trac.ffmpeg.org/wiki/EncodingForStreamingSites
    [twitch]="Twitch (x264:veryfast@3M/aac@160k)"
    [twitch.v]="-c:v libx264 -preset veryfast -b:v 3000k -maxrate 3000k -bufsize 6000k -pix_fmt yuv420p -g 60"
    [twitch.a]="-c:a aac -b:a 160k -ac 2 -ar 44100"

    # Wowza - see https://www.wowza.com/docs/how-to-live-stream-using-ffmpeg-with-wowza-streaming-engine
    [wowza]='Wowza (x264:medium@1mbps/aac@128k)'
    [wowza.v]="-c:v libx264 -g 60 -sc_threshold 0 -b:v 1024k -bufsize 1216k -maxrate 1280k -preset medium -profile:v main -tune film -bsf:v h264_mp4toannexb" 
    [wowza.a]="-c:a aac -b:a 128k -ac 2 -ar 48000 -af aresample=async=1:min_hard_comp=0.100000:first_pts=0"

    # Youtube
    [youtube]="Youtube (x264:veryfast@3M/aac@128k)"
    [youtube.v]="-c:v libx264 -preset veryfast -pix_fmt yuv420p -g 60 -x264-params keyint=60:min-keyint=60:scenecut=-1 -b:v 3000k -bufsize 6000k -crf 28"
    [youtube.a]="-c:a aac -b:a 128k -ac 2 -ar 44100"
)

# Source other encofing profile config files
for f in ./*.enc_profile.conf ./.enc_profile.conf /etc/enc_profile.conf ~/.enc_profile.conf; do
    [ -f $f ] && source $f
done

# Quitting when things go wrong
function vg_abort() {
   [ "$1" != "" ] && >&2 echo Error: $1
   kill -s TERM $$
}

# List available encoding profiles
function vg_list_profiles() {
    for p in "${!vg_profile[@]}"; do 
        case $1 in
            -n|--names)
                printf %-15s%s\\n "$p:" "${vg_profile[${p}]}"
                ;;
            "")
                echo $p
                ;;
            *)
                ;;
        esac
    done | grep -v \\.[va]$ | grep -v \\.[va]\: | sort
}

# return video encoding profile
# $1 : profile id
# $2 : profile type, a|v| - return both if empty
function vg_profile() {
    [ "${vg_profile[$1]}" == "" ] && vg_abort "encoding profile '$1' does not exist."
    if [ "$2" == "" ]; then
        echo "${vg_profile[$1.v]} ${vg_profile[$1.a]}"
    else 
        echo "${vg_profile[$1.$2]}"
    fi
}