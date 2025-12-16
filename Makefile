.PHONY: init watch build test format clean help vendor coverage

help:
	@echo "bullets - Elm presentation tool"
	@echo ""
	@echo "Available targets:"
	@echo "  make init     - Initialize project dependencies"
	@echo "  make vendor   - Download vendor JavaScript libraries"
	@echo "  make watch    - Start development server with auto-reload"
	@echo "  make build    - Build optimized production bundle"
	@echo "  make test     - Run test suite"
	@echo "  make coverage - Run test suite with detailed output"
	@echo "  make format   - Format all Elm source files"
	@echo "  make clean    - Remove build artifacts"

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
	@if [ ! -f vendor/pptxgen.bundle.js ]; then \
		echo "Downloading PptxGenJS..."; \
		curl -L -s https://cdn.jsdelivr.net/npm/pptxgenjs@3.12.0/dist/pptxgen.bundle.js -o vendor/pptxgen.bundle.js; \
	fi
	@if [ ! -f vendor/jszip.min.js ]; then \
		echo "Downloading JSZip..."; \
		curl -L -s https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js -o vendor/jszip.min.js; \
	fi
	@echo "Vendor libraries ready!"

watch: vendor
	@echo "Starting development server..."
	elm-live src/Main.elm --open --start-page=index.html -- --output=elm.js

build: vendor
	@echo "Building optimized production bundle..."
	elm make src/Main.elm --optimize --output=elm.js
	@echo "Build complete: elm.js"

test:
	@echo "Running test suite..."
	elm-test

coverage:
	@echo "Running test suite with detailed output..."
	@mkdir -p coverage
	@echo "<!DOCTYPE html><html><head><meta charset='UTF-8'><title>Bullets Test Coverage</title>" > coverage/index.html
	@echo "<style>body{font-family:sans-serif;margin:2rem;background:#f5f5f0}h1{color:#1a1a1a}" >> coverage/index.html
	@echo ".stats{background:#fff;padding:1.5rem;border-radius:8px;margin:1rem 0;box-shadow:0 2px 8px rgba(0,0,0,0.1)}" >> coverage/index.html
	@echo ".stat{display:inline-block;margin:0 2rem 0 0}.label{font-weight:bold;color:#666}" >> coverage/index.html
	@echo ".value{font-size:2rem;margin-left:0.5rem}.pass{color:#2a7}.fail{color:#d44}" >> coverage/index.html
	@echo "pre{background:#f0f0f0;padding:1rem;border-radius:4px;overflow-x:auto;white-space:pre-wrap}</style></head>" >> coverage/index.html
	@echo "<body><h1>🧪 Bullets Test Report</h1><div class='stats'>" >> coverage/index.html
	@elm-test 2>&1 | tee coverage/test-output.txt > /dev/null || true
	@PASSED=$$(grep "Passed:" coverage/test-output.txt | awk '{print $$2}' | head -1); \
	FAILED=$$(grep "Failed:" coverage/test-output.txt | awk '{print $$2}' | head -1); \
	if [ -z "$$PASSED" ]; then PASSED="0"; fi; \
	if [ -z "$$FAILED" ]; then FAILED="0"; fi; \
	echo "<div class='stat'><span class='label'>Tests Passed:</span><span class='value pass'>$$PASSED</span></div>" >> coverage/index.html; \
	echo "<div class='stat'><span class='label'>Tests Failed:</span><span class='value fail'>$$FAILED</span></div>" >> coverage/index.html
	@echo "</div><h2>Test Output</h2><pre>" >> coverage/index.html
	@cat coverage/test-output.txt >> coverage/index.html
	@echo "</pre><p><small>Generated on $$(date)</small></p></body></html>" >> coverage/index.html
	@echo ""
	@echo "✅ Coverage report generated: coverage/index.html"
	@echo "   Open with: xdg-open coverage/index.html"

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
