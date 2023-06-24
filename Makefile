# Project variables
ORG_NAME ?= warrior7089
	REPO_NAME := $(shell basename "$(PWD)")


CHECK := @bash -c '\
if [[ $(INSPECT) -ne 0 ]]; \
then exit $(INSPECT); fi' VALUE


# Use these settings to specify a custom Docker registry
DOCKER_REGISTRY ?= docker.io


# WARNING: Set DOCKER_REGISTRY_AUTH to empty for Docker Hub


.PHONY: vet test mod build docker_build docker_run docker_clean login logout publish docker_build_mutli


docker_run:
	${INFO} "Running the container..."
	@ docker run --rm -d -p 8081:8080 --name go-app $(DOCKER_REGISTRY)/$(ORG_NAME)/$(REPO_NAME):latest


docker_clean:
	${INFO} "Stopping and removing the container..."
	@ docker rm -f go-app


docker_build:
	${INFO} "Building images..."
	@ docker build --pull -t $(DOCKER_REGISTRY)/$(ORG_NAME)/$(REPO_NAME):latest .
	${INFO} "Tagging complete"


docker_build_mutli:
	${INFO} "Building images..."
	@ docker build --pull -t $(DOCKER_REGISTRY)/$(ORG_NAME)/$(REPO_NAME):latest -f Dockerfile.multistage .
	${INFO} "Tagging complete"

publish:
	${INFO} "Pushing images..."
	@ docker push $(DOCKER_REGISTRY)/$(ORG_NAME)/$(REPO_NAME):latest
	${INFO} "Pushing complete"	


login:
	${INFO} "Logging in to $(DOCKER_REGISTRY)"
	@ docker login $(DOCKER_REGISTRY)
	${INFO} "Logged in to $(DOCKER_REGISTRY)"

logout:
	${INFO} "Logging out from $(DOCKER_REGISTRY)"
	@ docker logout $(DOCKER_REGISTRY)
	${INFO} "Logged out from $(DOCKER_REGISTRY)"

vet:
	@ go vet $(go list ./... | grep -v /vendor/)


test:
	@ go test -race $(go list ./... | grep -v /vendor/)


mod:
	@ go mod download


build:
	@ go build -o . ./...


# Cosmetics
YELLOW := "\e[1;33m"
NC := "\e[0m"


# Shell Functions
INFO := @bash -c '\
printf $(YELLOW); \
echo "=> $$1"; \
printf $(NC)' SOME_VALUE
