# ----------------------------
# Project Configuration
# ----------------------------

VERSION_FILE := VERSION
PORT         := 5500
COMMIT_FROM  ?= HEAD~1
COMMIT_TO    ?= HEAD
PR_BASE_SHA  ?= $(COMMIT_FROM)
PR_HEAD_SHA  ?= $(COMMIT_TO)

# ----------------------------
# Default Target
# ----------------------------

.PHONY: help install serve lint lint-html lint-md lint-commit lint-commit-pr lighthouse check pr-check clean version

help: ## Show this help message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'


install: ## Install dependencies (if using npm)
	npm install

serve: ## Launch a local development server
	@echo "Serving at http://localhost:$(PORT)"
	python3 -m http.server $(PORT)

lint: lint-html ## Alias for HTML lint check

lint-html: ## Check HTML files for lint issues
	npx htmlhint "**/*.html"

clean: ## Remove temporary files and cache
	find . -name ".DS_Store" -delete
	rm -rf node_modules
	@echo "Cleaned up system junk."

lint-md: ## Check markdown files for formatting errors
	npx markdownlint "**/*.md" "#node_modules/**"

lint-commit: ## Check commit messages (override with COMMIT_FROM/COMMIT_TO)
	npx commitlint --from $(COMMIT_FROM) --to $(COMMIT_TO) --verbose

lint-commit-pr: ## Check PR commit messages (override with PR_BASE_SHA/PR_HEAD_SHA)
	npx commitlint --from $(PR_BASE_SHA) --to $(PR_HEAD_SHA) --verbose

lighthouse: ## Run Lighthouse CI checks
	npm run lighthouse

check: lint-commit lint-md lint-html lighthouse ## Run all quality checks

pr-check: lint-commit-pr lint-md lint-html lighthouse ## Run all checks for pull requests

version: ## Display the current project version
	@cat $(VERSION_FILE)
