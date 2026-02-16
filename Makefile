PROJECT   := nvim-config

.DEFAULT: help

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

.PHONY: format
format: ## Run stylua for all files in the lua directores
	fd --glob "*.lua" --exclude plugin/ --exec stylua --search-parent-directories

.PHONY: docs
docs: ## Generate docs
docs:
	uv run $(PROJECT) docs

.PHONY: clean
clean: ## Clean generated docs
clean:
	uv run $(PROJECT) clean

.PHONY: live
live: ## Generate live docs
live:
	uv run $(PROJECT) live

.PHONY: docker-shell-arch
docker-shell-arch: ## Start Arch Docker shell
	./docker/run-workflow.sh arch,standard

.PHONY: docker-shell-ubuntu
docker-shell-ubuntu: ## Start Ubuntu Docker shell (standard profile)
	./docker/run-workflow.sh ubuntu,standard

.PHONY: docker-shell-ubuntu-minimal
docker-shell-ubuntu-minimal: ## Start Ubuntu Docker shell (minimal profile)
	./docker/run-workflow.sh ubuntu,minimal
