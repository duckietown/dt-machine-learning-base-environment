
build:
	dts build_utils aido-container-build --ignore-untagged --force-login


push: build
	dts build_utils aido-container-push
