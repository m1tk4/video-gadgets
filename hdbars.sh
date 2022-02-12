#!/bin/bash

## 
# Produces test pattern with HD SMPTE Bars, local time, timecode, 
# and a beep every 1 s with visually matching indicator
#


help_and_bail() {
cat << EOF
usage: hdbars [options] <LogoFile.png> "<Title Text>" <outputFormat> <outputTarget>

Options:

    -t <duration>   duration in seconds or per ffmpeg format 
                    https://ffmpeg.org/ffmpeg-utils.html#time-duration-syntax),
                    indefinite and at realtime if not supplied

Parameters:

    LogoFile.png:   PNG file to insert, expected 135px wide;
    Title Text:     Text line to imprint, up to 20 characters;
    outputFormat:   ffmpeg target format, run ffmpeg -formats for the list;
    outputTarget:   target to send to;

EOF
exit 1
} 


# Parse the command line params
REALTIME="-re"
while [ ${1:0:1} == "-" ]
do
    case $1 in
        -t)
            REALTIME=""
            DURATION="duration=$2:"
            TOTAL_DURATION="-t $2"
            shift
            shift
            ;;
        *)
            help_and_bail
            ;;
    esac
done

[ "$#" -lt 4 ] && help_and_bail;
if [ ! -f "$1" ]; then
    echo "File '$1' does not exist"
    exit 1
fi
LOGO_SOURCE=$1
OUTPUT_FORMAT=$3
TARGET=$4

# Various Geometry Things
SW=1280
SH=720
FRAME_RATE=60000/1001
BOX_W=540
BOX_H=178
SHUTTLE_W=45
SHUTTLE_H=10
BOX_X=(${SW}-$BOX_W)/2
BOX_Y=(${SH}-$BOX_H)/3
MARGIN_X=20
MARGIN_Y=20
LINE_1=$2
FONT=/usr/share/fonts/dejavu/DejaVuSansMono-Bold.ttf
FONT_SIZE=32
LOGO_W=130
TEXT_OFFSET=10
LINE_H=44


ffmpeg \
    $REALTIME \
    -f lavfi -i "smptehdbars=${DURATION}size=${SW}x${SH}:rate=$FRAME_RATE" \
    -f lavfi -i "sine=${DURATION}frequency=220:beep_factor=8:sample_rate=44100" \
    -framerate $FRAME_RATE -i $LOGO_SOURCE \
    -f lavfi -i "color=r=$FRAME_RATE:c=#FFFFFF@0.6:s=${SHUTTLE_W}x${SHUTTLE_H},format=rgba" \
    -filter_complex " \
      drawbox=c=#000000@0.2:w=${BOX_W}:h=${BOX_H}:x=$BOX_X:y=$BOX_Y:t=fill [bg]; \
      [bg][2] overlay=x=$BOX_X+$MARGIN_X:y=$BOX_Y+$MARGIN_Y [bglogo]; \
      [bglogo][3] overlay=x=$BOX_X+ if(mod(floor(t)\,2)\,(ceil(t)-t)\,1-(ceil(t)-t)) *($BOX_W-$SHUTTLE_W):y=$BOX_H+$BOX_Y-$SHUTTLE_H, \
      drawbox=enable=lte(t-floor(t)\,0.025)+gte(t-floor(t)\,0.975):c=#FFFFFFCC:t=fill:x=$BOX_X:y=$BOX_H+$BOX_Y-$SHUTTLE_H:w=${BOX_W}:h=${SHUTTLE_H},
      drawtext=text='$LINE_1':rate=$FRAME_RATE:x=$BOX_X+$MARGIN_X*2+$LOGO_W:y=$BOX_Y+$MARGIN_Y+$TEXT_OFFSET:fontfile=$FONT:fontsize=$FONT_SIZE:fontcolor=white:shadowcolor=black:shadowx=0:shadowy=0, \
      drawtext=text='%{localtime\:%b %d %X}':rate=$FRAME_RATE:x=$BOX_X+$MARGIN_X*2+$LOGO_W:y=$BOX_Y+$MARGIN_Y+$TEXT_OFFSET+$LINE_H:fontfile=$FONT:fontsize=$FONT_SIZE:fontcolor=white:shadowcolor=black:shadowx=0:shadowy=0, \
      drawtext=timecode='00\:00\:00\;00':rate=$FRAME_RATE:x=$BOX_X+$MARGIN_X*2+$LOGO_W:y=$BOX_Y+$MARGIN_Y+$TEXT_OFFSET+$LINE_H*2:fontfile=$FONT:fontsize=$FONT_SIZE:fontcolor=white:shadowcolor=black:shadowx=0:shadowy=0 \
    " \
    -c:v libx264 -preset veryfast -g 60 \
    -c:a aac -ac 2 -ar 44100 -b:a 32k \
    -y \
    $TOTAL_DURATION \
    -f $OUTPUT_FORMAT \
    $TARGET
    