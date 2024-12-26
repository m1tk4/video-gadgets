RPM_DOCK_IMG=vgbuilder-rpm
RPM_DOCK_CTR=$(RPM_DOCK_IMG)c

RPM_BUILD_CMD=rpmbuild --define "_topdir `mktemp -d`" --define "build_version $(B_VERSION)" -ba pkg/rpm/video-gadgets.spec

build ::
	podman build --pull --rm --tag $(RPM_DOCK_IMG) --file pkg/rpm/Dockerfile .
	-@podman rm $(RPM_DOCK_CTR)
	podman run -v $(PWD):/home/build:Z --name $(RPM_DOCK_CTR) $(RPM_DOCK_IMG) $(RPM_BUILD_CMD)

clean ::
	-@podman container rm --force $(RPM_DOCK_CTR)
	-@rm -f dist/*.{rpm,tgz}

distclean ::
	-@rm -f dist/*.{rpm,tgz}
	-@podman image rm --force $(RPM_DOCK_IMG)
	-@podman image prune --force
	-@podman container prune --force
	-@podman container rm --force $(RPM_DOCK_CTR)
