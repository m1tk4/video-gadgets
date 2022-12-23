DEB_DOCK_IMG=vgbuilder-deb
DEB_DOCK_CTR=$(DEB_DOCK_IMG)c

#DEB_BUILD_CMD=pkg/deb/build $(B_VERSION)
DEB_BUILD_CMD=

# This in my dev env, on Rocky
build ::
	podman build --pull --rm --tag $(DEB_DOCK_IMG) --file pkg/deb/Dockerfile .
	-@podman rm --force $(DEB_DOCK_CTR)
	podman run -v $(PWD):/home/build:Z \
		--name $(DEB_DOCK_CTR) $(DEB_DOCK_IMG) \
		/usr/bin/bash pkg/deb/build.sh $(B_VERSION)

# This runs on Github, in Ubuntu context
build-ci ::
	$(DEB_BUILD_CMD)

clean ::
	-@podman container rm --force $(DEB_DOCK_CTR)
	-@rm -f dist/*.deb

distclean ::
	-@rm -f dist/*.deb
	-@podman image rm --force $(DEB_DOCK_IMG)
	-@podman image prune --force
	-@podman container prune --force
	-@podman container rm --force $(DEB_DOCK_CTR)
