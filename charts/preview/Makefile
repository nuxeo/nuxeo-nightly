OS := $(shell uname)

preview:
ifeq ($(OS),Darwin)
	sed -i "" -e "s/version:.*/version: $(VERSION)/" Chart.yaml
	sed -i "" -e "s/version:.*/version: $(VERSION)/" ../*/Chart.yaml
	sed -i "" -e "s|repository:.*|repository: $(DOCKER_REGISTRY)\/$(ORG)\/nuxeo-nightly-ui|" values.yaml
	sed -i "" -e "s/tag:.*/tag: $(VERSION)/" values.yaml
	sed -i "" -e "s/packages:.*/packages: $(NUXEO_PACKAGES)/" values.yaml
else ifeq ($(OS),Linux)
	sed -i -e "s/version:.*/version: $(VERSION)/" Chart.yaml
	sed -i -e "s/version:.*/version: $(VERSION)/" ../*/Chart.yaml
	sed -i -e "s|repository:.*|repository: $(DOCKER_REGISTRY)\/$(ORG)\/nuxeo-nightly-ui|" values.yaml
	sed -i -e "s/tag:.*/tag: $(VERSION)/" values.yaml
	sed -i -e "s/packages:.*/packages: $(NUXEO_PACKAGES)/" values.yaml
else
	echo "platform $(OS) not supported to release from"
	exit -1
endif
	jx step helm build