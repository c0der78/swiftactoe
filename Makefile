
DOCKER ?= podman
CMD := SwifTacToe
NAME := swiftactoe
ADDRESS := ipc:///tmp/$(NAME).ipc
LOGFILE ?= $(CMD).log

.PHONY: run build image help server client

all: help

help:
	@echo ""
	@echo "Building:"
	@echo ""
	@echo "  build        build the program"
	@echo ""
	@echo "Single player:"
	@echo ""
	@echo "  run          run in singleplayer"
	@echo ""
	@echo "Multi player:"
	@echo ""
	@echo "  server       host a game ($(ADDRESS))"
	@echo "  client       join a hosted game"
	@echo ""
	@echo "Container:"
	@echo ""
	@echo "  image        include to run as a container with $(DOCKER)"
	@echo "               example: '$(MAKE) image server'"
	@echo ""

image:
	@$(eval IMAGE := swiftactoe)

run:
	@if test -z "$(IMAGE)"; then \
		swift run 2> $(LOGFILE); \
	else \
	  $(DOCKER) run --name $(IMAGE) -it $(IMAGE) 2> $(LOGFILE); \
	fi

build:
	@if test -z "$(IMAGE)"; then \
		swift build; \
	else \
		$(DOCKER) build -t $(IMAGE) . ; \
	fi

server:
	@if test -z "$(IMAGE)"; then \
		swift run $(CMD) -s -a $(ADDRESS) 2> $(LOGFILE); \
	else \
	  $(DOCKER) volume create $(IMAGE) || test true; \
		$(DOCKER) run --name $(IMAGE) -v $(IMAGE):$(IPCDIR) -it $(IMAGE) -s -a $(ADDRESS) 2> $(LOGFILE); \
	fi

client:
	@if test -z "$(IMAGE)"; then \
		swift run $(CMD) -j -a $(ADDRESS) 2> $(LOGFILE); \
	else \
	  $(DOCKER) volume create $(IMAGE) || test true; \
		$(DOCKER) run --name $(IMAGE) -v $(IMAGE):$(IPCDIR) -it $(IMAGE) -j -a $(ADDRESS) 2> $(LOGFILE); \
	fi
