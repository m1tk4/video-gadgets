RPM_DOCK_IMG=vgbuilder-rpm
RPM_DOCK_CTR=$(RPM_DOCK_IMG)c

RPM_BUILD_CMD=rpmbuild --define "_topdir `mktemp -d`" --define "build_version $(B_VERSION)" -ba pkg/rpm/video-gadgets.spec

build ::
	docker build --pull --rm --tag $(RPM_DOCK_IMG) --file pkg/rpm/Dockerfile .
	-@docker rm $(RPM_DOCK_CTR)
	docker run -v $(PWD):/home/build --user="`id -u`:`id -g`" --name $(RPM_DOCK_CTR) $(RPM_DOCK_IMG) $(RPM_BUILD_CMD)

clean ::
	-@docker container rm --force $(RPM_DOCK_CTR)
	-@rm -f dist/*.{rpm,tgz}

distclean ::
	-@rm -f dist/*.{rpm,tgz}
	-@docker image rm --force $(RPM_DOCK_IMG)
	-@docker image prune --force
	-@docker container prune --force
	-@docker container rm --force $(RPM_DOCK_CTR)
