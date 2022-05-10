.DEFAULT: help

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST) | sort

.PHONY: format
format: ## Run stylua for all files in the lua directores
	fd --glob "*.lua" --exclude plugin/ --exec stylua --search-parent-directories
