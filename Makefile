IMAGE=m1tk4-video-gadgets-build
DEFAULT_RPM=video-gadgets.rpm

# If not passed from command line, this will read the last tag which is supposed to be something like v1.2.3
BUILD_VERSION?=$(shell git describe --tags --abbrev=0)

build:
	docker build --pull --rm --tag $(IMAGE) .
	-docker rm $(IMAGE)-ctr
	docker run -v $(PWD):/home/build --name $(IMAGE)-ctr $(IMAGE) rpmbuild --define "build_version $(subst v,,$(BUILD_VERSION))" -ba video-gadgets.spec

clean:
	-docker image rm --force $(IMAGE)
	-docker image prune --force
	-docker container prune --force
	-docker container rm $(IMAGE)-ctr
	-rm -rf noarch *.mp4 *.rpm *.tgz

# Animation for README.md showing hdbars output
hdbars-ani:
	./hdbars -h m1tk4 -d 2 mp4 /tmp/tmp.hdbars.mkv
	./gif_encode --width 640 --fps 30 /tmp/tmp.hdbars.mkv assets/hdbars-screenshot.gif
