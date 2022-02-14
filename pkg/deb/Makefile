DEB_DOCK_IMG=vgbuilder-deb
DEB_DOCK_CTR=$(DEB_DOCK_IMG)c

#DEB_BUILD_CMD=pkg/deb/build $(B_VERSION)
DEB_BUILD_CMD=

# This in my dev env, on Rocky
build ::
	docker build --pull --rm --tag $(DEB_DOCK_IMG) --file pkg/deb/Dockerfile .
	-@docker rm --force $(DEB_DOCK_CTR)
	docker run -v $(PWD):/home/build --user="`id -u`:`id -g`" \
		--name $(DEB_DOCK_CTR) $(DEB_DOCK_IMG) \
		/usr/bin/bash pkg/deb/build.sh $(B_VERSION)

# This runs on Github, in Ubuntu context
build-ci ::
	$(DEB_BUILD_CMD)

clean ::
	-@docker container rm --force $(DEB_DOCK_CTR)
	-@rm -f dist/*.deb

distclean ::
	-@rm -f dist/*.deb
	-@docker image rm --force $(DEB_DOCK_IMG)
	-@docker image prune --force
	-@docker container prune --force
	-@docker container rm --force $(DEB_DOCK_CTR)
