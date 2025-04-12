.PHONY: build-amd64 build-arm64 build-multiarch build-multiarch-push cleanx push all

# Build Vars
IMAGENAME=dezmodue/netshoot-no-root
VERSION=0.13.0


.DEFAULT_GOAL := all

build-amd64:
	    @docker build --platform linux/amd64 -t ${IMAGENAME}:${VERSION}-amd64 .
build-arm64:
		@docker build --platform linux/arm64 -t ${IMAGENAME}:${VERSION}-arm64 .
build-all:
		docker buildx create --use --name multiarch --driver docker-container
		@docker buildx build --platform linux/amd64,linux/arm64 --output "type=image,push=false" --file ./Dockerfile.noroot .
build-all-push:
		docker buildx create --use --name multiarch --driver docker-container
		@docker buildx build --push --tag ${IMAGENAME}:${VERSION} --platform linux/amd64,linux/arm64 --output "type=image,push=false" --file ./Dockerfile.noroot .
cleanx:
		docker buildx stop multiarch
		docker buildx rm multiarch
push:
	 	@docker push ${IMAGENAME}:${VERSION} 

build-multiarch: build-all cleanx

build-multiarch-push: build-all-push cleanx

all: build-all cleanx push


		
