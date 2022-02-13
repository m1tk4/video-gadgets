IMAGE=m1tk4-video-gadgets-build
DEFAULT_RPM=video-gadgets.rpm

build:
	-mkdir noarch
	-rm noarch/$(DEFAULT_RPM)
	-docker container rm $(IMAGE)-ctr
	docker build --pull --rm --tag $(IMAGE) .
	docker run -v $(PWD):/home/build --name $(IMAGE)-ctr -ti $(IMAGE) rpmbuild -ba video-gadgets.spec
	cp -f noarch/*.rpm noarch/$(DEFAULT_RPM)

clean:
	-docker image rm --force $(IMAGE)
	-docker image prune --force
	-docker container prune --force
	-docker container rm $(IMAGE)-ctr
	-rm -rf noarch *.mp4
