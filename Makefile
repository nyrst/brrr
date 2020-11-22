all: build

OSUPPER = $(shell uname -s 2>/dev/null | tr [:lower:] [:upper:])
DARWIN = $(strip $(findstring DARWIN, $(OSUPPER)))

ifneq ($(DARWIN),)
	export PKG_CONFIG_PATH=$(shell printenv PKG_CONFIG_PATH):/usr/local/opt/openssl/lib/pkgconfig
endif

build: clean-bin ## Build brrr
	shards build

clean-bin: ## Clean bin folder
	rm -rf bin

build-static:
	docker run --rm -it -v ${CURDIR}:/workspace -w /workspace crystallang/crystal:0.35.1-alpine sh /workspace/build.sh

build-release: clean-bin test ## Build brrr for release
	shards build --release

dev: ## Run in dev mode with reloading
	watchexec -w src make build

install: ## Install dependencies for brrr
	shards install

update: ## Update dependencies
	shards update

test: ## Run tests
	crystal spec

check-target: ## Check that TARGET is present
ifndef ARCH
	$(error ARCH is undefined (make release-archive ARCH=linux))
endif

release-archive: build-release check-target ## Make a tar.gz archive from the binary
	cd bin ;\
	tar czf brrr-$(ARCH).tar.gz *

help: ## Print this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: all build build-release dev install update check-target release-archive
