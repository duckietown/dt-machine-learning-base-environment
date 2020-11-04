
build:
	dts build_utils update-reqs 
	dts build_utils aido-container-build --ignore-untagged  --ignore-dirty --force-login


push: build
	dts build_utils aido-container-push
