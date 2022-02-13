IMAGE=m1tk4-video-gadgets-build
DEFAULT_RPM=video-gadgets.rpm
BUILD_VERSION?=v0.0.0

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
