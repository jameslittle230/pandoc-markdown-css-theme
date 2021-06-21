#
# Author: Jake Zimmerman <jake@zimmerman.io>
#
# ===== Usage ================================================================
#
# make                  Prepare docs/ folder (all markdown & assets)
# make docs/index.html  Recompile just docs/index.html
# make docs             Copy all public/ assets into docs/
#
# make watch            Start a local HTTP server and rebuild on changes
# PORT=4242 make watch  Like above, but use port 4242
#
# make clean            Delete all generated files
#
# ============================================================================

BASEURL := /pandoc-markdown-css-theme

SOURCES := $(shell find src -type f -name '*.md')
TARGETS := $(patsubst src/%.md,docs/%.html,$(SOURCES))

.PHONY: all
all: docs/.nojekyll $(TARGETS)

.PHONY: clean
clean:
	rm -rf $(TARGETS)

.PHONY: watch
watch:
	./tools/serve.sh --watch

docs/.nojekyll: $(wildcard public/*) public/.nojekyll
	rm -vrf docs && mkdir -p docs && shopt -s nullglob && cp -vr public/.nojekyll public/* docs

.PHONY: docs
docs: docs/.nojekyll

# Generalized rule: how to build a .html file from each .md
# Note: you will need pandoc 2 or greater for this to work
# TODO(jez) --css options will break on GitHub Pages
docs/%.html: src/%.md template.html5 Makefile
	mkdir -p $$(dirname $@) && \
	pandoc \
		--katex \
		--from markdown+tex_math_single_backslash \
		--filter pandoc-sidenote \
		--to html5+smart \
		--template=template \
		--css=$(BASEURL)/css/theme.css \
		--css=$(BASEURL)/css/skylighting-solarized-theme.css \
		--toc \
		--output $@ \
		$<


