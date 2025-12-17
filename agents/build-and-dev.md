# Build and Development Environment Documentation

**Purpose**: Complete guide to the development environment setup, build system, and tooling for the bullets presentation tool.

**Last Updated**: 2025-12-17

## Overview

The bullets project uses a modern, reproducible development environment powered by Nix flakes, with a streamlined Makefile-based build system. This ensures consistent development environments across all contributors and CI/CD systems.

## Development Environment

### Nix Flakes Setup

The project uses **Nix flakes** for reproducible development environment management. The configuration is defined in `flake.nix`.

#### Environment Components

**Elm Tools**:
- `elm` - Elm compiler (0.19.1)
- `elm-format` - Code formatter
- `elm-test` - Test runner
- `elm-review` - Static analysis and linting
- `elm-language-server` - LSP for editor integration
- `elm-live` - Development server with hot reload

**Runtime & Build Tools**:
- `nodejs_20` - Node.js runtime (required for elm-live and editor tooling)
- `python3` with `python-pptx` - Python environment for test utilities

#### Entering the Development Environment

```bash
nix develop
```

This command:
1. Activates the flake-defined development shell
2. Makes all tools available in your PATH
3. Displays a welcome message with version info
4. Ensures reproducible environment across machines

#### Environment Verification

After entering the dev shell, verify tools are available:

```bash
elm --version        # Should show Elm 0.19.1
node --version       # Should show Node.js v20.x
python --version     # Should show Python 3.x
elm-test --version   # Verify elm-test is available
```

## Build System

### Makefile Overview

The project uses a comprehensive Makefile with these targets:

| Target | Purpose | Dependencies |
|--------|---------|--------------|
| `make help` | Display available targets and descriptions | None |
| `make init` | Initialize project (first-time setup) | Creates dirs, downloads vendor libs |
| `make vendor` | Download external JavaScript libraries | Creates vendor/ directory |
| `make watch` | Development server with auto-reload | vendor |
| `make build` | Production build with optimization | vendor |
| `make test` | Run unit test suite | None |
| `make coverage` | Generate HTML test coverage report | None |
| `make format` | Format all Elm source files | None |
| `make clean` | Remove build artifacts | None |

### Target Details

#### `make init`

First-time project initialization:
- Creates `src/` and `tests/` directories
- Initializes Elm project with `elm init`
- Downloads vendor libraries
- Sets up project structure

**When to use**: First time setting up the project, or after `make clean` removes everything.

#### `make vendor`

Downloads external JavaScript libraries into `vendor/` directory:
- **PptxGenJS** (3.12.0) - PowerPoint export functionality
  - Source: `https://cdn.jsdelivr.net/npm/pptxgenjs@3.12.0/dist/pptxgen.bundle.js`
- **JSZip** (3.10.1) - ZIP file handling for PPTX import
  - Source: `https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js`

**Idempotent**: Only downloads if files don't exist.

**Note**: Vendor files are NOT committed to the repository. They are downloaded during build.

#### `make watch`

Development mode with hot reload:
- Uses `elm-live` for development server
- Watches for file changes and recompiles
- Opens browser automatically (`--open`)
- Serves from `index.html`
- Compiles `src/Main.elm` → `elm.js`

**Usage**:
```bash
make watch
# Opens browser at http://localhost:8000
# Edit files and see changes immediately
```

**Port**: Default is 8000 (configurable in elm-live)

#### `make build`

Production build with optimization:
- Compiles `src/Main.elm` → `elm.js`
- Uses `--optimize` flag for minification and performance
- Ensures vendor libraries are present
- Output: `elm.js` (optimized bundle)

**Usage**:
```bash
make build
# Creates optimized elm.js
```

**Output size**: Typically ~100KB optimized (vs ~200KB+ debug build)

#### `make test`

Runs the unit test suite:
- Uses `elm-test` to run all tests in `tests/` directory
- Reports pass/fail with details
- Exits with non-zero code on failure (CI-friendly)

**Current status**: 146 unit tests passing

**Usage**:
```bash
make test
# Runs all tests, shows results
```

#### `make coverage`

Generates HTML coverage report:
- Runs `elm-test` and captures output
- Parses test results
- Generates styled HTML report at `coverage/index.html`
- Shows passed/failed test counts
- Includes full test output

**Usage**:
```bash
make coverage
# Generates coverage/index.html
# Open with: xdg-open coverage/index.html
```

**Output files**:
- `coverage/index.html` - Styled HTML report
- `coverage/test-output.txt` - Raw test output

#### `make format`

Formats all Elm source files:
- Uses `elm-format --yes` for automatic formatting
- Formats `src/` directory
- Formats `tests/` directory (if exists)
- Enforces consistent code style

**Usage**:
```bash
make format
# Formats all .elm files in-place
```

**When to use**: Before every commit

#### `make clean`

Removes build artifacts:
- Deletes `elm.js` (compiled output)
- Removes `elm-stuff/` (Elm build cache)
- Does NOT remove `vendor/` (use `git clean` for that)

**Usage**:
```bash
make clean
# Cleans build artifacts
```

## Vendor Library Management

### Strategy

External JavaScript libraries are:
1. **Not committed** to the repository (in `.gitignore`)
2. **Downloaded during build** via `make vendor`
3. **Cached locally** after first download
4. **Served locally** in both dev and production

### Libraries Used

**PptxGenJS** (3.12.0):
- Purpose: PowerPoint PPTX export
- Size: ~500KB minified bundle
- License: MIT
- Used by: Export PPTX functionality

**JSZip** (3.10.1):
- Purpose: ZIP file handling for PPTX import
- Size: ~100KB minified
- License: MIT/GPL
- Used by: Import PPTX functionality

### Integration

Libraries are loaded in `index.html`:
```html
<script src="vendor/jszip.min.js"></script>
<script src="vendor/pptxgen.bundle.js"></script>
```

They must be loaded BEFORE `elm.js` to ensure global objects are available.

## CI/CD Pipeline

### GitHub Actions Workflow

Defined in `.github/workflows/deploy.yml` with three jobs:

#### Job 1: Test

Runs on every push to main:
- Checks out code
- Sets up Elm 0.19.1
- Sets up Node.js 20
- Installs elm-test globally
- Runs test suite
- Blocks deployment if tests fail

#### Job 2: Build

Runs after tests pass:
- Checks out code
- Sets up Elm 0.19.1
- Downloads vendor libraries
- Compiles optimized production build
- Creates `_site/` directory with:
  - `index.html`
  - `elm.js` (optimized)
  - `vendor/` directory
- Uploads artifact for deployment

#### Job 3: Deploy

Deploys to GitHub Pages:
- Runs after build succeeds
- Deploys `_site/` artifact
- Updates GitHub Pages site
- Provides deployment URL

### Deployment URL

Production site: `https://<username>.github.io/bullets/`

### Workflow Triggers

- Automatically on push to `main` branch
- Manual trigger via GitHub Actions UI

## Development Workflow

### Daily Development

1. **Enter Nix shell**:
   ```bash
   nix develop
   ```

2. **Start dev server**:
   ```bash
   make watch
   ```

3. **Edit code** - changes auto-reload in browser

4. **Format before commit**:
   ```bash
   make format
   ```

5. **Run tests**:
   ```bash
   make test
   ```

6. **Commit changes**:
   ```bash
   git add <files>
   git commit -m "Description"
   ```

### Production Build

1. **Clean build**:
   ```bash
   make clean
   make build
   ```

2. **Test locally**:
   - Open `index.html` in browser
   - Verify all features work

3. **Push to main**:
   ```bash
   git push origin main
   ```

4. **Verify deployment**:
   - Check GitHub Actions status
   - Visit GitHub Pages URL

## Troubleshooting

### Vendor Libraries Missing

**Symptom**: Console errors about `PptxGenJS` or `JSZip` not defined

**Solution**:
```bash
make vendor
# Or
rm -rf vendor && make vendor
```

### Elm Compilation Errors

**Symptom**: Build fails with type errors

**Solution**:
1. Read error message carefully
2. Fix type issues
3. Run `elm-format` to ensure proper formatting
4. Clear cache if needed: `rm -rf elm-stuff`

### Test Failures

**Symptom**: `make test` shows failing tests

**Solution**:
1. Read test output to identify failing test
2. Fix the issue
3. Verify with `make test`
4. Never commit with failing tests

### Development Server Issues

**Symptom**: `make watch` fails or doesn't reload

**Solution**:
1. Kill any existing elm-live processes
2. Ensure port 8000 is free
3. Try `make clean && make watch`
4. Check browser console for errors

### Nix Environment Issues

**Symptom**: Tools not found in PATH

**Solution**:
1. Exit and re-enter nix shell: `exit` then `nix develop`
2. Update flake inputs: `nix flake update`
3. Verify flake.nix is correct
4. Check Nix installation: `nix --version`

### GitHub Actions Failures

**Symptom**: CI pipeline fails

**Common causes**:
- Test failures (check test job logs)
- Vendor download issues (network problems)
- Elm compilation errors (type issues)
- Permission issues (check workflow permissions)

**Solution**:
1. Check Actions tab on GitHub
2. Review job logs
3. Reproduce locally with same commands
4. Fix issue and push again

## Performance Considerations

### Build Times

- **Development build** (`make watch`): ~2-5 seconds
- **Production build** (`make build`): ~5-10 seconds
- **Test suite** (`make test`): ~3-5 seconds

### Optimization

The `--optimize` flag in production builds:
- Minifies generated JavaScript
- Removes debug helpers
- Enables advanced optimizations
- Reduces bundle size by ~50%

### Caching

Elm uses aggressive caching:
- `elm-stuff/` contains compiled dependencies
- Recompiles only changed modules
- Vendor libraries cached after first download

## Tools and Utilities

### elm-live

Development server with features:
- Hot reload on file changes
- Serves static files
- Opens browser automatically
- WebSocket-based reload (no extensions needed)

### elm-format

Code formatter that:
- Enforces consistent style
- Formats on save (in most editors)
- Can be run via Makefile
- Based on Elm community standards

### elm-test

Test runner that:
- Discovers tests in `tests/` directory
- Runs tests in Node.js environment
- Supports describe/test structure
- Provides detailed failure output

### elm-review

Static analysis tool that:
- Checks code quality
- Enforces best practices
- Configured in `review/` directory
- Can auto-fix some issues

## Editor Integration

### Recommended Setup

1. **Install language server**: Included in Nix flake
2. **Configure your editor**:
   - VS Code: Install "Elm" extension
   - Vim/Neovim: Configure with CoC or native LSP
   - Emacs: Use elm-mode with LSP
3. **Enable format on save**: Uses elm-format
4. **Configure linting**: Uses elm-review

### VS Code Configuration

Add to `.vscode/settings.json`:
```json
{
  "elm.formatOnSave": true,
  "elm.compiler": "elm",
  "elm.makeCommand": "make"
}
```

## See Also

- [Architecture Documentation](./architecture.md)
- [Testing Documentation](./testing.md) (to be created)
- [Workflow Documentation](./workflow.md) (to be created)
- [Dependencies Documentation](./dependencies.md) (to be created)
- [Main Agent Index](../AGENTS.md)

## Maintenance Notes

Update this document when:
- New Makefile targets are added
- Nix flake dependencies change
- Vendor libraries are updated or added
- GitHub Actions workflow is modified
- New build tools are introduced
- CI/CD pipeline changes
