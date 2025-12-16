.PHONY: init watch build test format clean help

help:
	@echo "bullets - Elm presentation tool"
	@echo ""
	@echo "Available targets:"
	@echo "  make init    - Initialize project dependencies"
	@echo "  make watch   - Start development server with auto-reload"
	@echo "  make build   - Build optimized production bundle"
	@echo "  make test    - Run test suite"
	@echo "  make format  - Format all Elm source files"
	@echo "  make clean   - Remove build artifacts"

init:
	@echo "Initializing Elm project..."
	elm init
	@echo "Creating source directory structure..."
	mkdir -p src
	mkdir -p tests
	@echo "Project initialized!"

watch:
	@echo "Starting development server..."
	elm-live src/Main.elm --open --start-page=index.html -- --output=elm.js

build:
	@echo "Building optimized production bundle..."
	elm make src/Main.elm --optimize --output=elm.js
	@echo "Build complete: elm.js"

test:
	@echo "Running test suite..."
	elm-test

format:
	@echo "Formatting Elm source files..."
	elm-format --yes src/
	@if [ -n "$$(find tests -name '*.elm' 2>/dev/null)" ]; then \
		elm-format --yes tests/; \
	fi

clean:
	@echo "Cleaning build artifacts..."
	rm -f elm.js
	rm -rf elm-stuff
	@echo "Clean complete!"
