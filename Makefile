.PHONY: init watch build test format clean help vendor

help:
	@echo "bullets - Elm presentation tool"
	@echo ""
	@echo "Available targets:"
	@echo "  make init    - Initialize project dependencies"
	@echo "  make vendor  - Download vendor JavaScript libraries"
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
	@echo "Downloading vendor libraries..."
	$(MAKE) vendor
	@echo "Project initialized!"

vendor:
	@echo "Downloading vendor JavaScript libraries..."
	@mkdir -p vendor
	@echo "Downloading PptxGenJS..."
	@curl -L -s https://cdn.jsdelivr.net/npm/pptxgenjs@3.12.0/dist/pptxgen.bundle.js -o vendor/pptxgen.bundle.js
	@echo "Downloading JSZip..."
	@curl -L -s https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js -o vendor/jszip.min.js
	@echo "Vendor libraries downloaded!"

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
