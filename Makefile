
build:
	dts build_utils update-reqs
	dts build_utils aido-container-build --use-branch daffy --ignore-untagged  --ignore-dirty --force-login


push: build
	dts build_utils aido-container-push --use-branch daffy
