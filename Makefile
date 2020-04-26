all: build

build: ## Build beulogue
	shards build

build-release: ## Build beulogue for release
	shards build --release

dev: ## Run in dev mode with reloading
	watchexec -w src make build

install: ## Install dependencies for beulogue
	shards install

update: ## Update dependencies
	shards update


check-target: ## Check that TARGET is present
ifndef ARCH
	$(error ARCH is undefined (make release-archive ARCH=linux))
endif

release-archive: build-release check-target ## Make a tar.gz archive from the binary
	cd bin ;\
	tar czf brrr-$(ARCH).tar.gz brrr

help: ## Print this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: all build build-release dev install update check-target release-archive
