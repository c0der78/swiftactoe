
DOCKER ?= podman
CMD := swiftactoe

.PHONY: run build container image help

all: help

help:
	@echo "run          build and run the program"
	@echo "build        build the program"
	@echo "container    build and run the container"
	@echo "image        build the container image"
	@echo ""

run:
	@swift run

build:
	@swift build

container: image
	@$(DOCKER) run --name $(CMD) -it $(CMD)

image:
	@$(DOCKER) build -t $(CMD) .