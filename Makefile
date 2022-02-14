
# Get the BUILD_VERSION from command line or set to 0.0.0
BUILD_VERSION?=v0.0.0
B_VERSION:=$(subst v,,$(BUILD_VERSION))

# Entry point
build_all: build

# Note: the order of these is meaningful as .deb builds rely on RPM builds
# to collecti all the right files for them
# build recipes actually will be there
include pkg/rpm/Makefile
include pkg/deb/Makefile

clean ::
	-@rm -rf *.mp4

# Animation for README.md showing hdbars output
hdbars-ani:
	./hdbars -h m1tk4 -d 2 mp4 /tmp/tmp.hdbars.mkv
	./gif_encode --width 640 --fps 30 /tmp/tmp.hdbars.mkv assets/hdbars-screenshot.gif
