IMAGE=m1tk4-video-gadgets-build
DEFAULT_RPM=video-gadgets.rpm

build:
	-mkdir noarch
	-docker container rm $(IMAGE)-ctr
	docker build --pull --rm --tag $(IMAGE) .
	docker run -v $(PWD):/home/build --name $(IMAGE)-ctr $(IMAGE) rpmbuild -ba video-gadgets.spec

clean:
	-docker image rm --force $(IMAGE)
	-docker image prune --force
	-docker container prune --force
	-docker container rm $(IMAGE)-ctr
	-rm -rf noarch *.mp4
