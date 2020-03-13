# Go params
GOCMD=go
GOBUILD = $(GOCMD) build
GOCLEAN = $(GOCMD) clean
GOTEST = $(GOCMD) test
GOGET = $(GOCMD) get

# Version information
GIT_CHECKSUM = $(shell git rev-parse --short HEAD)
GIT_VERSION ?= dev

all: build

build:
	$(GOBUILD) -ldflags "-s -w -X main.GitChecksum=$(GIT_CHECKSUM) -X main.GitVersion=$(GIT_VERSION)" ./...

test:
	$(GOTEST) -cover -v ./...

clean:
	$(GOCLEAN)

deps:
	$(GOGET) -u

.PHONY: clean all
