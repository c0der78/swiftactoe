
DOCKER ?= podman
CMD := swiftactoe

.PHONY: run build

all: run

run: build
	@$(DOCKER) run --name swiftactoe -it $(CMD)

build:
	@$(DOCKER) build -t $(CMD) .