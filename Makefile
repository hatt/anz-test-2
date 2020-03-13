# Go params
GOCMD = go
GOBUILD = $(GOCMD) build
GOCLEAN = $(GOCMD) clean
GOTEST = $(GOCMD) test
GOGET = $(GOCMD) get

# Docker image params
APP_NAME = anz-test-2
APP_REPO = docker.pkg.github.com/hatt/$(APP_NAME)/$(APP_NAME)

# Version information
GIT_CHECKSUM = $(shell git rev-parse --short HEAD)
GIT_VERSION ?= dev

all: build

build:
	$(GOBUILD) -ldflags "-s -w -X main.GitChecksum=$(GIT_CHECKSUM) -X main.GitVersion=$(GIT_VERSION)" ./...

clean:
	$(GOCLEAN)

deps:
	$(GOGET) -u

docker-build: build
	docker build -t $(APP_NAME) .

publish: publish-latest publish-version

publish-latest:
	@echo "publishing tag latest to $(APP_REPO)"
	docker push $(APP_REPO):latest

publish-version:
	@echo "publishing tag $(GIT_VERSION) to $(APP_REPO)"
	docker push $(APP_REPO):$(GIT_VERSION)

tag: tag-latest tag-version

tag-latest:
	@echo "create tag latest"
	docker tag $(APP_NAME) $(APP_REPO):latest

tag-version:
	@echo "create tag $(GIT_VERSION)"
	docker tag $(APP_NAME) $(APP_REPO):$(GIT_VERSION)

test:
	$(GOTEST) -cover -v ./...

.PHONY: clean all
