# ─── isbhuvan.github.io — Content & Build Makefile ───────────────────────────
#
# Content authoring
#   make new-post   TOPIC=<topic> SLUG=<slug>   Scaffold a new blog post
#   make new-series SLUG=<slug>                  Scaffold a new learning series
#
# Validation (used locally and in GitHub Actions CI)
#   make validate            Validate all content (posts + series)
#   make validate-posts      Blog posts only
#   make validate-series     Series only
#
# Listings
#   make list-posts          All published posts (slug, date, tags)
#   make list-drafts         Draft posts only
#   make list-series         All series (slug, status, part count, title)
#
# Lint & quality (mirrors GitHub Actions CI)
#   make lint-md             Markdown lint (markdownlint-cli2)
#   make lint-html           HTML lint after build (htmlhint)
#   make type-check          Astro + TypeScript type check
#   make audit               npm dependency vulnerability audit
#   make check-links         Dead-link check on built HTML (lychee)
#   make lighthouse          Lighthouse CI performance / a11y / SEO scores
#   make ci                  Run all CI checks in order (local dry-run)
#
# Dev & build
#   make dev | build | preview | check | clean | bootstrap

SHELL := /bin/bash

BLOG_DIR   := src/content/blog
SERIES_DIR := src/content/series
TOPIC      ?=
SLUG       ?=

.PHONY: help dev build preview check clean bootstrap \
        new-post new-series \
        validate validate-posts validate-series \
        list-posts list-drafts list-series \
        lint-md lint-html type-check audit check-links lighthouse ci

.DEFAULT_GOAL := help

# ─── Colours ──────────────────────────────────────────────────────────────────
BOLD  := \033[1m
RESET := \033[0m
RED   := \033[31m
GREEN := \033[32m
YELLOW:= \033[33m
CYAN  := \033[36m
DIM   := \033[2m

# ─── Help ─────────────────────────────────────────────────────────────────────
help:
	@printf '\n$(BOLD)isbhuvan.github.io$(RESET)  — content & build tooling\n\n'
	@printf '$(CYAN)Content$(RESET)\n'
	@printf '  make new-post   TOPIC=<topic> SLUG=<slug>   Scaffold a new blog post\n'
	@printf '  make new-series SLUG=<slug>                  Scaffold a new learning series\n'
	@printf '\n$(CYAN)Validation$(RESET)\n'
	@printf '  make validate                                Validate all content\n'
	@printf '  make validate-posts                          Blog posts only\n'
	@printf '  make validate-series                         Series only\n'
	@printf '\n$(CYAN)Listings$(RESET)\n'
	@printf '  make list-posts                              All published posts\n'
	@printf '  make list-drafts                             Draft posts only\n'
	@printf '  make list-series                             All series\n'
	@printf '\n$(CYAN)Lint & Quality$(RESET)\n'
	@printf '  make lint-md                                 Markdown lint (markdownlint-cli2)\n'
	@printf '  make lint-html                               HTML lint on built output (htmlhint)\n'
	@printf '  make type-check                              Astro + TypeScript type check\n'
	@printf '  make audit                                   Dependency vulnerability audit\n'
	@printf '  make check-links                             Dead-link check on built HTML\n'
	@printf '  make lighthouse                              Lighthouse CI scores\n'
	@printf '  make ci                                      Run all CI checks locally\n'
	@printf '\n$(CYAN)Dev & Build$(RESET)\n'
	@printf '  make dev                                     Dev server at localhost:4321\n'
	@printf '  make build                                   Production build to ./dist/\n'
	@printf '  make preview                                 Preview production build\n'
	@printf '  make check                                   Alias for type-check\n'
	@printf '  make clean                                   Remove dist/\n'
	@printf '  make bootstrap                               Install deps + verify structure\n\n'

# ─── Dev & Build ──────────────────────────────────────────────────────────────
dev:
	npm run dev

build:
	npm run build

preview:
	npm run preview

type-check:
	npx astro check

check: type-check

clean:
	rm -rf dist/
	@printf 'Removed dist/\n'

bootstrap:
	@printf '$(BOLD)Installing dependencies...$(RESET)\n'
	npm install
	@printf '$(BOLD)Verifying content directories...$(RESET)\n'
	@mkdir -p $(BLOG_DIR) $(SERIES_DIR)
	@printf '$(GREEN)Bootstrap complete.$(RESET) Run $(BOLD)make dev$(RESET) to start.\n'

# ─── Lint & Quality ───────────────────────────────────────────────────────────
lint-md:
	@printf '$(BOLD)Markdown lint...$(RESET)\n'
	npx markdownlint-cli2 "**/*.md" "#node_modules/**"
	@printf '$(GREEN)Markdown lint passed.$(RESET)\n'

lint-html: build
	@printf '$(BOLD)HTML lint...$(RESET)\n'
	npx htmlhint "dist/**/*.html"
	@printf '$(GREEN)HTML lint passed.$(RESET)\n'

audit:
	@printf '$(BOLD)Dependency audit...$(RESET)\n'
	npm audit --audit-level=high
	@printf '$(GREEN)Audit passed.$(RESET)\n'

check-links: build
	@printf '$(BOLD)Checking links...$(RESET)\n'
	@if command -v lychee >/dev/null 2>&1; then \
		lychee --no-progress --root-dir dist --config .lychee.toml './dist/**/*.html'; \
		printf '$(GREEN)Link check passed.$(RESET)\n'; \
	else \
		printf '$(YELLOW)lychee not installed — skipping link check.$(RESET)\n'; \
		printf '$(DIM)Install: https://lychee.cli.rs$(RESET)\n'; \
	fi

lighthouse: build
	@printf '$(BOLD)Lighthouse CI...$(RESET)\n'
	@if command -v google-chrome >/dev/null 2>&1 || command -v chromium >/dev/null 2>&1 || command -v chromium-browser >/dev/null 2>&1; then \
		npx @lhci/cli autorun; \
		printf '$(GREEN)Lighthouse passed.$(RESET)\n'; \
	else \
		printf '$(YELLOW)Chrome not installed — skipping Lighthouse locally.$(RESET)\n'; \
		printf '$(DIM)Lighthouse runs in CI (GitHub Actions) where Chrome is available.$(RESET)\n'; \
	fi

# ─── CI (local dry-run — mirrors GitHub Actions) ──────────────────────────────
ci: lint-md type-check audit validate build lint-html check-links lighthouse
	@SEP=$$(printf '%0.s─' {1..50}); printf '%s\n' "$$SEP"; \
	printf '$(GREEN)$(BOLD)All CI checks passed.$(RESET)\n\n'

# ─── New Post ─────────────────────────────────────────────────────────────────
# Usage: make new-post TOPIC=kubernetes SLUG=my-new-post
new-post:
	@[ -n "$(TOPIC)" ] || { \
		printf '$(RED)Error:$(RESET) TOPIC is required.\n'; \
		printf 'Usage: make new-post TOPIC=kubernetes SLUG=my-post\n'; \
		exit 1; \
	}
	@[ -n "$(SLUG)" ] || { \
		printf '$(RED)Error:$(RESET) SLUG is required.\n'; \
		printf 'Usage: make new-post TOPIC=kubernetes SLUG=my-post\n'; \
		exit 1; \
	}
	@FILE="$(BLOG_DIR)/$(TOPIC)/$(SLUG).md"; \
	if [ -f "$$FILE" ]; then \
		printf '$(RED)Error:$(RESET) %s already exists\n' "$$FILE"; \
		exit 1; \
	fi; \
	mkdir -p "$(BLOG_DIR)/$(TOPIC)"; \
	TODAY=$$(date +%Y-%m-%d); \
	printf -- \
'---\ntitle: ""\ndescription: ""\ndate: %s\n# updatedAt: %s  # uncomment and set when revising published content\nauthor: "Bhuvan"\ntags: []\nfeatured: false\ndraft: true\n# series: ""   # slug from src/content/series/ — e.g. "production-kubernetes-azure"\n# part: 1      # part number within the series (1-based)\n# readTime: "" # e.g. "12 min" — auto-calculated from word count if omitted\n---\n\n## Introduction\n\nWrite your introduction here.\n' \
		"$$TODAY" "$$TODAY" > "$$FILE"; \
	printf '$(GREEN)Created:$(RESET) %s\n\n' "$$FILE"; \
	printf '$(BOLD)Required before publishing (draft: false):$(RESET)\n'; \
	printf '  title        Short, descriptive title\n'; \
	printf '  description  One-sentence summary for cards and SEO\n'; \
	printf '  date         Publication date (auto-filled)\n'; \
	printf '  tags         At least one tag\n'; \
	printf '\n$(BOLD)Optional:$(RESET)\n'; \
	printf '  series       Slug of the parent series (sets the Part N banner)\n'; \
	printf '  part         Part number within the series\n'; \
	printf '  readTime     Overrides the auto-calculated reading time\n'; \
	printf '  updatedAt    Set when content changes meaningfully after publication\n'; \
	printf '\n$(BOLD)When ready:$(RESET)\n'; \
	printf '  1. Set $(BOLD)draft: false$(RESET)\n'; \
	printf '  2. Add the post slug to the relevant series file in $(SERIES_DIR)/\n\n'

# ─── New Series ───────────────────────────────────────────────────────────────
# Usage: make new-series SLUG=my-new-series
new-series:
	@[ -n "$(SLUG)" ] || { \
		printf '$(RED)Error:$(RESET) SLUG is required.\n'; \
		printf 'Usage: make new-series SLUG=my-new-series\n'; \
		exit 1; \
	}
	@FILE="$(SERIES_DIR)/$(SLUG).md"; \
	if [ -f "$$FILE" ]; then \
		printf '$(RED)Error:$(RESET) %s already exists\n' "$$FILE"; \
		exit 1; \
	fi; \
	printf -- \
'---\ntitle: ""\ndescription: ""\nlevel: "intermediate"       # beginner | intermediate | advanced\nhours: 0                    # total estimated reading time in hours\nstatus: "active"            # active | complete\nstatusLabel: "In progress"  # shown in UI, e.g. "In progress" or "Complete"\ntopics: []                  # tag-like topics for filtering\nobjectives:\n  - ""\nprerequisites:\n  - ""\nmodules:\n  - heading: ""\n    posts:\n      - slug: ""        # blog post filename without .md and without topic folder\n        title: ""       # display title in the curriculum list\n        readTime: ""    # e.g. "12 min"\niconPath: "M4 19.5A2.5 2.5 0 0 1 6.5 17H20 M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"\naccentHue: "220"            # HSL hue for the accent colour\n---\n\nWrite the "About this Series" body text here.\n' \
		> "$$FILE"; \
	printf '$(GREEN)Created:$(RESET) %s\n\n' "$$FILE"; \
	printf '$(BOLD)Required fields:$(RESET)\n'; \
	printf '  title, description, level, hours, status, statusLabel\n'; \
	printf '\n$(BOLD)For each module post:$(RESET)\n'; \
	printf '  slug      Filename of the blog post (without .md, without topic folder)\n'; \
	printf '  title     Display title shown in the curriculum list\n'; \
	printf '  readTime  Estimated reading time, e.g. "12 min"\n'; \
	printf '\n$(BOLD)Note:$(RESET) Published status is computed automatically from the blog collection.\n'; \
	printf '  No "done" flag is needed — set draft: false on the post to mark it live.\n'; \
	printf '\n$(BOLD)Next steps:$(RESET)\n'; \
	printf '  1. Fill in title, description, level, hours, topics\n'; \
	printf '  2. Add objectives and prerequisites\n'; \
	printf '  3. Define modules and post slugs\n'; \
	printf '  4. Create each post with: make new-post TOPIC=<topic> SLUG=<slug>\n'; \
	printf '  5. Set series: "<this-slug>" and part: N in each blog post frontmatter\n\n'

# ─── Validate Posts ───────────────────────────────────────────────────────────
validate-posts:
	@printf '\n$(BOLD)Validating blog posts...$(RESET)\n'
	@errors=0; \
	files=$$(find $(BLOG_DIR) -name "*.md" 2>/dev/null | sort); \
	if [ -z "$$files" ]; then \
		printf '  $(YELLOW)No posts found in $(BLOG_DIR)$(RESET)\n\n'; \
		exit 0; \
	fi; \
	for f in $$files; do \
		ok=1; \
		slug=$$(basename "$$f" .md); \
		if ! grep -q "^title:" "$$f"; then \
			printf '  $(RED)FAIL$(RESET)  %s  missing field: title\n' "$$f"; \
			errors=$$((errors+1)); ok=0; \
		elif grep -qE "^title: (\"\"|\x27\x27)$$" "$$f"; then \
			printf '  $(RED)FAIL$(RESET)  %s  title is empty\n' "$$f"; \
			errors=$$((errors+1)); ok=0; \
		fi; \
		if ! grep -q "^date:" "$$f"; then \
			printf '  $(RED)FAIL$(RESET)  %s  missing field: date\n' "$$f"; \
			errors=$$((errors+1)); ok=0; \
		elif ! grep -qE "^date: [0-9]{4}-[0-9]{2}-[0-9]{2}" "$$f"; then \
			printf '  $(RED)FAIL$(RESET)  %s  date is not YYYY-MM-DD\n' "$$f"; \
			errors=$$((errors+1)); ok=0; \
		fi; \
		if ! grep -q "^tags:" "$$f"; then \
			printf '  $(RED)FAIL$(RESET)  %s  missing field: tags\n' "$$f"; \
			errors=$$((errors+1)); ok=0; \
		fi; \
		if grep -q "^draft:" "$$f"; then \
			dval=$$(grep "^draft:" "$$f" | awk '{print $$2}' | tr -d '"'); \
			case "$$dval" in \
				true|false) ;; \
				*) printf '  $(RED)FAIL$(RESET)  %s  draft must be true or false (got: %s)\n' "$$f" "$$dval"; \
				   errors=$$((errors+1)); ok=0 ;; \
			esac; \
		fi; \
		[ $$ok -eq 1 ] && printf '  $(GREEN)ok$(RESET)    %s\n' "$$f"; \
	done; \
	printf '\n$(BOLD)Checking for duplicate slugs...$(RESET)\n'; \
	dups=$$(find $(BLOG_DIR) -name "*.md" -exec basename {} .md \; | sort | uniq -d); \
	if [ -n "$$dups" ]; then \
		while IFS= read -r dup; do \
			printf '  $(RED)FAIL$(RESET)  duplicate slug "%s" — found in:\n' "$$dup"; \
			find $(BLOG_DIR) -name "$$dup.md" | sed 's/^/            /'; \
			errors=$$((errors+1)); \
		done <<< "$$dups"; \
	else \
		printf '  $(GREEN)ok$(RESET)    No duplicate slugs\n'; \
	fi; \
	printf '\n'; \
	if [ $$errors -eq 0 ]; then \
		printf '$(GREEN)All posts valid.$(RESET)\n\n'; \
	else \
		printf '$(RED)%d error(s) found in posts.$(RESET)\n\n' "$$errors"; exit 1; \
	fi

# ─── Validate Series ──────────────────────────────────────────────────────────
validate-series:
	@printf '\n$(BOLD)Validating series...$(RESET)\n'
	@errors=0; warnings=0; \
	files=$$(find $(SERIES_DIR) -name "*.md" 2>/dev/null | sort); \
	if [ -z "$$files" ]; then \
		printf '  $(YELLOW)No series found in $(SERIES_DIR)$(RESET)\n\n'; \
		exit 0; \
	fi; \
	for f in $$files; do \
		ok=1; \
		for field in title description level hours status statusLabel; do \
			if ! grep -q "^$$field:" "$$f"; then \
				printf '  $(RED)FAIL$(RESET)  %s  missing field: %s\n' "$$f" "$$field"; \
				errors=$$((errors+1)); ok=0; \
			fi; \
		done; \
		if grep -q "^level:" "$$f"; then \
			lv=$$(grep "^level:" "$$f" | awk '{print $$2}' | tr -d '"'); \
			case "$$lv" in \
				beginner|intermediate|advanced) ;; \
				*) printf '  $(RED)FAIL$(RESET)  %s  level must be beginner|intermediate|advanced (got: %s)\n' "$$f" "$$lv"; \
				   errors=$$((errors+1)); ok=0 ;; \
			esac; \
		fi; \
		if grep -q "^status:" "$$f"; then \
			st=$$(grep "^status:" "$$f" | awk '{print $$2}' | tr -d '"'); \
			case "$$st" in \
				active|complete) ;; \
				*) printf '  $(RED)FAIL$(RESET)  %s  status must be active|complete (got: %s)\n' "$$f" "$$st"; \
				   errors=$$((errors+1)); ok=0 ;; \
			esac; \
		fi; \
		if grep -q "^hours:" "$$f"; then \
			hrs=$$(grep "^hours:" "$$f" | awk '{print $$2}'); \
			if ! echo "$$hrs" | grep -qE "^[0-9]+(\.[0-9]+)?$$"; then \
				printf '  $(RED)FAIL$(RESET)  %s  hours must be a number (got: %s)\n' "$$f" "$$hrs"; \
				errors=$$((errors+1)); ok=0; \
			fi; \
		fi; \
		for slug in $$(grep -E "^\s+- slug:" "$$f" | awk '{print $$NF}' | tr -d '"'); do \
			[ -z "$$slug" ] && continue; \
			[ "$$slug" = '""' ] && continue; \
			if ! find $(BLOG_DIR) -name "$$slug.md" 2>/dev/null | grep -q .; then \
				printf '  $(YELLOW)WARN$(RESET)  %s  module slug "%s" has no matching blog post\n' "$$f" "$$slug"; \
				warnings=$$((warnings+1)); \
			fi; \
		done; \
		[ $$ok -eq 1 ] && printf '  $(GREEN)ok$(RESET)    %s\n' "$$f"; \
	done; \
	printf '\n'; \
	[ $$warnings -eq 0 ] || printf '$(YELLOW)%d warning(s)$(RESET) — module slugs with no matching post (may be planned posts).\n' "$$warnings"; \
	if [ $$errors -eq 0 ]; then \
		printf '$(GREEN)All series valid.$(RESET)\n\n'; \
	else \
		printf '$(RED)%d error(s) found in series.$(RESET)\n\n' "$$errors"; exit 1; \
	fi

# ─── Validate All ─────────────────────────────────────────────────────────────
validate: validate-posts validate-series
	@SEP=$$(printf '%0.s─' {1..50}); printf '%s\n' "$$SEP"; \
	printf '$(GREEN)$(BOLD)All content validated successfully.$(RESET)\n\n'

# ─── List Posts ───────────────────────────────────────────────────────────────
list-posts:
	@printf '\n$(BOLD)Published posts$(RESET)\n\n'
	@printf '$(DIM)%-40s  %-12s  %s$(RESET)\n' 'SLUG' 'DATE' 'TAGS'
	@printf '$(DIM)%s$(RESET)\n' "$$(printf '%0.s─' {1..72})"
	@count=0; \
	for f in $$(find $(BLOG_DIR) -name "*.md" 2>/dev/null | sort -r); do \
		draft=$$(grep "^draft:" "$$f" | awk '{print $$2}' | tr -d '"'); \
		[ "$$draft" = "true" ] && continue; \
		slug=$$(basename "$$f" .md); \
		date=$$(grep "^date:" "$$f" | awk '{print $$2}'); \
		tags=$$(grep "^tags:" "$$f" | sed 's/^tags: //; s/\[//g; s/\]//g; s/"//g; s/, / /g'); \
		printf '%-40s  %-12s  %s\n' "$$slug" "$$date" "$$tags"; \
		count=$$((count+1)); \
	done; \
	printf '\n$(DIM)%d post(s)$(RESET)\n\n' "$$count"

# ─── List Drafts ──────────────────────────────────────────────────────────────
list-drafts:
	@printf '\n$(BOLD)Draft posts$(RESET)\n\n'
	@count=0; \
	for f in $$(find $(BLOG_DIR) -name "*.md" 2>/dev/null | sort); do \
		draft=$$(grep "^draft:" "$$f" | awk '{print $$2}' | tr -d '"'); \
		[ "$$draft" = "true" ] || continue; \
		slug=$$(basename "$$f" .md); \
		title=$$(grep "^title:" "$$f" | sed 's/^title: //; s/"//g'); \
		topic=$$(basename "$$(dirname "$$f")"); \
		printf '  %-40s  $(DIM)%s / %s$(RESET)\n' "$$slug" "$$topic" "$$title"; \
		count=$$((count+1)); \
	done; \
	[ $$count -gt 0 ] || printf '  $(DIM)(no drafts)$(RESET)\n'; \
	printf '\n$(DIM)%d draft(s)$(RESET)\n\n' "$$count"

# ─── List Series ──────────────────────────────────────────────────────────────
list-series:
	@printf '\n$(BOLD)Series$(RESET)\n\n'
	@printf '$(DIM)%-38s  %-10s  %-6s  %s$(RESET)\n' 'SLUG' 'STATUS' 'PARTS' 'TITLE'
	@printf '$(DIM)%s$(RESET)\n' "$$(printf '%0.s─' {1..72})"
	@for f in $$(find $(SERIES_DIR) -name "*.md" 2>/dev/null | sort); do \
		slug=$$(basename "$$f" .md); \
		title=$$(grep "^title:" "$$f" | sed 's/^title: //; s/"//g'); \
		status=$$(grep "^status:" "$$f" | awk '{print $$2}' | tr -d '"'); \
		parts=$$(grep -cE "^\s+- slug:" "$$f" 2>/dev/null || echo 0); \
		done_parts=$$(grep -c "done: true" "$$f" 2>/dev/null || echo 0); \
		[ "$$status" = "active" ] \
			&& label="$(YELLOW)active$(RESET)" \
			|| label="$(GREEN)complete$(RESET)"; \
		printf '%-38s  %-10b  %-6s  %s\n' "$$slug" "$$label" "$$done_parts/$$parts" "$$title"; \
	done
	@printf '\n'
