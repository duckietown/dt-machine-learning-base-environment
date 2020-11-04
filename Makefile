
build:
	dts build_utils aido-container-build --ignore-untagged


push: build
	dts build_utils aido-container-push
