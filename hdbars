#!/bin/bash

## 
# Produces test pattern with HD SMPTE Bars, local time, timecode, 
# and a beep every 1 s with visually matching indicator
#


help_and_bail() {
cat << EOF
usage: hdbars [options] <LogoFile.png> "<Title Text>" <outputFormat> <outputTarget>

Options:

    -d <duration>   
    --duration <duration>
            duration in seconds or per ffmpeg format 
            https://ffmpeg.org/ffmpeg-utils.html#time-duration-syntax),
            output will be paced in realtime if duration is not 
            supplied
    
    -h <header>
    --header <header>
            Header text to display, defaults to hostname

    -f <framerate>
    --framerate <framerate>
            Framerate to use, default is 60000/1001 == 59.94

    -l <filename>
    --logo <filename>
            logo file to use, expected ~135 px wide

Parameters:

    Title Text:     Text line to imprint, up to 20 characters;
    outputFormat:   ffmpeg target format, run ffmpeg -formats for the list;
    outputTarget:   target to send to;

EOF
exit 1
} 

# Parse the command line params
REALTIME="-re"
FONT=/usr/share/fonts/dejavu/DejaVuSansMono-Bold.ttf
LINE_1=`hostname -s`
FRAME_RATE=60000/1001
DROPFRAME=";"
while [ ${1:0:1} == "-" ]
do
    case $1 in
        -d|--duration)
            REALTIME=""
            DURATION="duration=$2:"
            TOTAL_DURATION="-t $2"
            shift 2
            ;;
        -l|--logo)
            if [ ! -f "$2" ]; then
                >&2 echo "File '$2' does not exist"
                exit 1
            fi
            LOGO_SOURCE="$2"
            shift 2
            ;;
        -h|--header)
            LINE_1=$2
            shift 2
            ;;
        -f|--framerate)
            FRAME_RATE=$2
            # fix the timecode separator for whole framerates
            [[ "$FRAME_RATE" =~ ^[0-9]+$ ]] && DROPFRAME=":"
            shift 2
            ;;
        *)
            help_and_bail
            ;;
    esac
done

[ "$#" -lt 2 ] && help_and_bail;
OUTPUT_FORMAT=$1
TARGET=$2

# Various Geometry Things
SW=1280
SH=720
BOX_W=540
BOX_H=178
SHUTTLE_W=45
SHUTTLE_H=10
BOX_X=(${SW}-$BOX_W)/2
BOX_Y=(${SH}-$BOX_H)/3
MARGIN_X=20
MARGIN_Y=20
FONT_SIZE=32
LOGO_W=135
TEXT_OFFSET=10
LINE_H=44
if [ "$LOGO_SOURCE" == "" ]; then 
    LOGO_SOURCE="-f lavfi -i smptebars=${DURATION}size=${LOGO_W}x$(( LOGO_W * 3 / 4 )):rate=$FRAME_RATE"
else
    LOGO_SOURCE="-framerate $FRAME_RATE -i $LOGO_SOURCE"
fi

# Run FFMPEG
ffmpeg \
    $REALTIME \
    -f lavfi -i "smptehdbars=${DURATION}size=${SW}x${SH}:rate=$FRAME_RATE" \
    -f lavfi -i "sine=${DURATION}frequency=220:beep_factor=8:sample_rate=44100" \
    $LOGO_SOURCE \
    -f lavfi -i "color=r=$FRAME_RATE:c=#FFFFFF@0.6:s=${SHUTTLE_W}x${SHUTTLE_H},format=rgba" \
    -filter_complex " \
      drawbox=c=#000000@0.2:w=${BOX_W}:h=${BOX_H}:x=$BOX_X:y=$BOX_Y:t=fill [bg]; \
      [bg][2] overlay=x=$BOX_X+$MARGIN_X:y=$BOX_Y+$MARGIN_Y [bglogo]; \
      [bglogo][3] overlay=x=$BOX_X+ if(mod(floor(t)\,2)\,(ceil(t)-t)\,1-(ceil(t)-t)) *($BOX_W-$SHUTTLE_W):y=$BOX_H+$BOX_Y-$SHUTTLE_H, \
      drawbox=enable=lte(t-floor(t)\,0.025)+gte(t-floor(t)\,0.975):c=#FFFFFFCC:t=fill:x=$BOX_X:y=$BOX_H+$BOX_Y-$SHUTTLE_H:w=${BOX_W}:h=${SHUTTLE_H},
      drawtext=text='$LINE_1':rate=$FRAME_RATE:x=$BOX_X+$MARGIN_X*2+$LOGO_W:y=$BOX_Y+$MARGIN_Y+$TEXT_OFFSET:fontfile=$FONT:fontsize=$FONT_SIZE:fontcolor=white:shadowcolor=black:shadowx=0:shadowy=0, \
      drawtext=text='%{localtime\:%b %d %X}':rate=$FRAME_RATE:x=$BOX_X+$MARGIN_X*2+$LOGO_W:y=$BOX_Y+$MARGIN_Y+$TEXT_OFFSET+$LINE_H:fontfile=$FONT:fontsize=$FONT_SIZE:fontcolor=white:shadowcolor=black:shadowx=0:shadowy=0, \
      drawtext=timecode='00\:00\:00\\${DROPFRAME}00':rate=$FRAME_RATE:x=$BOX_X+$MARGIN_X*2+$LOGO_W:y=$BOX_Y+$MARGIN_Y+$TEXT_OFFSET+$LINE_H*2:fontfile=$FONT:fontsize=$FONT_SIZE:fontcolor=white:shadowcolor=black:shadowx=0:shadowy=0 \
    " \
    -c:v libx264 -preset veryfast -g 60 \
    -c:a aac -ac 2 -ar 44100 -b:a 32k \
    -y \
    $TOTAL_DURATION \
    -f $OUTPUT_FORMAT \
    $TARGET
