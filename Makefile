
build:
	dts build_utils update-reqs
	dts build_utils aido-container-build --use-branch ente --ignore-untagged  --ignore-dirty --force-login


push: build
	dts build_utils aido-container-push --use-branch ente
