# Dependencies Documentation

**Purpose**: Comprehensive guide to all external dependencies, their purposes, versions, and integration rationale for the bullets presentation tool.

**Last Updated**: 2024-12-17

## Overview

The bullets project uses a carefully curated set of dependencies to maintain a minimal, reliable codebase. Dependencies are divided into: Elm packages (managed by elm.json), JavaScript vendor libraries (downloaded at build time), and development tools (provided by Nix flake).

## Dependency Philosophy

### Principles

- **Minimal**: Only include necessary dependencies
- **Stable**: Prefer mature, well-maintained packages
- **Compatible**: Ensure compatibility with Elm 0.19.1
- **Secure**: Use reputable sources and verify integrity
- **Documented**: Understand what each dependency does

### Dependency Review

Before adding a dependency:
1. Is it necessary? Can we implement it ourselves?
2. Is it maintained? Check last update date
3. Is it compatible? Works with Elm 0.19.1
4. Is it reputable? Known author or organization
5. What's the license? Compatible with project

## Elm Dependencies

Managed in `elm.json` via `elm install`.

### Direct Dependencies

#### elm/browser (1.0.2)

**Purpose**: Core application framework for browser-based Elm applications.

**What it provides**:
- `Browser.document` - Document-based application (used by bullets)
- `Browser.element` - Embedded Elm component
- `Browser.sandbox` - Simple application without side effects
- `Browser.application` - SPA with routing

**Used in**: `src/Main.elm` for application structure

**Why we need it**: Essential for any browser-based Elm application

**License**: BSD-3-Clause

**Alternatives**: None, standard Elm platform package

#### elm/core (1.0.5)

**Purpose**: Elm's standard library with fundamental data structures and functions.

**What it provides**:
- Basic types: String, Int, Float, Bool
- Collections: List, Array, Dict, Set
- Maybe and Result types
- Common functions: map, filter, fold, etc.

**Used in**: Every Elm file

**Why we need it**: Core language functionality, automatically included

**License**: BSD-3-Clause

**Alternatives**: None, required by Elm

#### elm/html (1.0.1)

**Purpose**: HTML rendering and view construction.

**What it provides**:
- HTML elements: div, span, button, input, etc.
- Attributes: class, id, style, href, etc.
- Events: onClick, onInput, onMouseDown, etc.

**Used in**: All view modules (`View.Edit`, `View.Present`, `MarkdownView`)

**Why we need it**: Core rendering library for UI

**License**: BSD-3-Clause

**Alternatives**: None, standard Elm package

#### elm/json (1.1.4)

**Purpose**: JSON encoding and decoding for data persistence.

**What it provides**:
- Decoders: string, int, list, field, maybe, etc.
- Encoders: encode, string, int, list, object, etc.
- Error handling: Decode.Error, errorToString

**Used in**: `src/Json.elm` for local storage serialization

**Why we need it**: Essential for saving/loading presentations and PPTX data exchange

**License**: BSD-3-Clause

**Alternatives**: None, standard JSON library

#### elm/file (1.0.5)

**Purpose**: File upload and download functionality.

**What it provides**:
- File.Select: selectFiles, selectFile
- File.Download: string, bytes, url
- File type and metadata access

**Used in**: Import PPTX, Export PPTX, Image upload features

**Why we need it**: Required for file I/O in browser

**License**: BSD-3-Clause

**Alternatives**: None, standard file handling package

#### dillonkearns/elm-markdown (7.0.1)

**Purpose**: Markdown parsing and rendering to HTML.

**What it provides**:
- Markdown.Parser: Parse markdown text to AST
- Markdown.Renderer: Render AST to HTML
- Custom renderers: Customize output
- CommonMark-compliant parsing

**Used in**: `src/MarkdownView.elm` for slide content rendering

**Why we need it**: Core feature - markdown-based slide content

**License**: BSD-3-Clause

**Alternatives**:
- pablohirafuji/elm-markdown: Older, less maintained
- Write our own: Too complex for limited benefit

**Rationale**: Most actively maintained Elm markdown library with excellent customization options

### Indirect Dependencies

Automatically installed as dependencies of direct dependencies.

#### elm/bytes (1.0.8)
- Required by: elm/file
- Purpose: Low-level bytes handling

#### elm/parser (1.1.0)
- Required by: dillonkearns/elm-markdown
- Purpose: Parser combinators for markdown parsing

#### elm/regex (1.0.0)
- Required by: dillonkearns/elm-markdown
- Purpose: Regular expressions in markdown parser

#### elm/time (1.0.0)
- Required by: elm/browser
- Purpose: Time and timezone handling

#### elm/url (1.0.0)
- Required by: elm/browser
- Purpose: URL parsing and building

#### elm/virtual-dom (1.0.5)
- Required by: elm/html
- Purpose: Efficient DOM diffing and patching

#### rtfeldman/elm-hex (1.0.0)
- Required by: dillonkearns/elm-markdown
- Purpose: Hexadecimal encoding/decoding

### Test Dependencies

#### elm-explorations/test (2.2.0)

**Purpose**: Unit testing framework for Elm.

**What it provides**:
- Test: test, describe, todo, skip
- Expect: Assertions (equal, notEqual, ok, err, etc.)
- Fuzz: Property-based testing (fuzzWith, string, int, etc.)
- Test.Runner: Test execution

**Used in**: All test files in `tests/` directory

**Why we need it**: Essential for unit testing

**License**: BSD-3-Clause

**Alternatives**:
- avh4/elm-firetruck: Older, deprecated
- None recommended

#### elm/random (1.0.0)

**Purpose**: Random value generation for fuzz testing.

**What it provides**:
- Random generators
- Seeded random generation

**Used in**: Indirectly by elm-explorations/test for fuzz testing

**Why we need it**: Required by test framework

**License**: BSD-3-Clause

## JavaScript Vendor Libraries

Downloaded at build time via `make vendor`. Not committed to repository.

### PptxGenJS (3.12.0)

**Purpose**: PowerPoint PPTX file generation in JavaScript.

**Source**: `https://cdn.jsdelivr.net/npm/pptxgenjs@3.12.0/dist/pptxgen.bundle.js`

**Size**: ~500KB minified bundle

**What it provides**:
- Create PowerPoint presentations
- Add slides with text and images
- Layout management
- Export to PPTX file

**Used in**: Export PPTX functionality via Elm ports

**Why we need it**: Core feature - PowerPoint export

**License**: MIT

**Alternatives**:
- officegen: Node.js only, not browser-compatible
- Write our own: Too complex, PPTX is complex format
- Use server: Would require backend, losing simplicity

**Integration**:
```javascript
// In index.html
app.ports.exportToPPTX.subscribe(function(data) {
    let pres = new PptxGenJS();
    // Add slides from data
    pres.writeFile({ fileName: 'presentation.pptx' });
});
```

**Version rationale**: 3.12.0 is stable, well-tested, good browser support

### JSZip (3.10.1)

**Purpose**: ZIP file creation and extraction in JavaScript.

**Source**: `https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js`

**Size**: ~100KB minified

**What it provides**:
- Load ZIP files (including PPTX)
- Extract files from ZIP
- Read file contents
- Async API with Promises

**Used in**: Import PPTX functionality via Elm ports

**Why we need it**: PPTX files are ZIP archives - need to read them

**License**: MIT/GPL dual-license (we use MIT)

**Alternatives**:
- zip.js: More complex API
- fflate: Newer but less mature
- Use server: Would lose client-side simplicity

**Integration**:
```javascript
// In index.html
JSZip.loadAsync(file)
    .then(function(zip) {
        // Extract slides, images, etc.
    });
```

**Version rationale**: 3.10.1 is latest stable with good browser support

### Vendor Library Management

**Download strategy**:
```makefile
vendor:
    @mkdir -p vendor
    @if [ ! -f vendor/pptxgen.bundle.js ]; then
        curl -L -s https://cdn.jsdelivr.net/...
    fi
```

**Benefits**:
- Not committed to repository (reduces repo size)
- Downloaded on demand
- Cached locally after first download
- Served locally (no runtime CDN dependency)

**Risks and Mitigations**:
- **Risk**: CDN goes down during build
  - Mitigation: Cache in CI, use reliable CDNs
- **Risk**: Malicious code injection
  - Mitigation: Pin to specific versions, use HTTPS
- **Risk**: Version drift
  - Mitigation: Pin exact versions in Makefile

## Development Tools

Provided by Nix flake. Not committed, managed by Nix.

### Elm Toolchain

#### elm (0.19.1)

**Purpose**: Elm compiler

**Provided by**: `pkgs.elmPackages.elm`

**Why we need it**: Compiles Elm source to JavaScript

**Version**: 0.19.1 (latest stable Elm version)

#### elm-format (0.8.x)

**Purpose**: Code formatter

**Provided by**: `pkgs.elmPackages.elm-format`

**Why we need it**: Enforces consistent code style

**Used in**: `make format`

#### elm-test (0.19.1-revision17)

**Purpose**: Test runner

**Provided by**: `pkgs.elmPackages.elm-test`

**Why we need it**: Runs unit test suite

**Used in**: `make test`, `make coverage`

#### elm-review (2.13.x)

**Purpose**: Static analysis and linting

**Provided by**: `pkgs.elmPackages.elm-review`

**Why we need it**: Code quality checks

**Used in**: Manual code review

#### elm-language-server

**Purpose**: Language Server Protocol implementation

**Provided by**: `pkgs.elmPackages.elm-language-server`

**Why we need it**: Editor integration (autocomplete, errors, etc.)

**Used in**: VS Code, Vim, Emacs Elm plugins

#### elm-live

**Purpose**: Development server with hot reload

**Provided by**: `pkgs.elmPackages.elm-live`

**Why we need it**: Development mode with auto-reload

**Used in**: `make watch`

### Runtime Tools

#### Node.js (20.x)

**Purpose**: JavaScript runtime for tooling

**Provided by**: `pkgs.nodejs_20`

**Why we need it**:
- Required by elm-live
- Required by elm-test
- Required by editor tooling

**Not used for**: Production runtime (app runs in browser)

#### Python (3.x)

**Purpose**: Test utilities

**Provided by**: `pkgs.python3.withPackages`

**Packages**: `python-pptx`

**Why we need it**: `create_test_pptx.py` for creating test PPTX files

**Used in**: Development testing only

## Dependency Updates

### When to Update

- **Security patches**: Update immediately
- **Bug fixes**: Update when issues arise
- **New features**: Evaluate if needed
- **Major versions**: Plan carefully, test thoroughly

### Update Process

#### Elm Packages

```bash
# Check for updates
elm outdated

# Update specific package
elm install dillonkearns/elm-markdown@7.0.2

# Update all (carefully)
# Review each update in elm.json
```

#### Vendor Libraries

Update URLs in `Makefile`:
```makefile
# Change version number
curl ... pptxgenjs@3.13.0/dist/...
```

Then:
```bash
rm -rf vendor
make vendor
make build
# Test thoroughly
```

#### Development Tools

Update `flake.nix`:
```nix
# Usually uses latest from nixos-unstable
# Specific versions can be pinned if needed
```

Update flake:
```bash
nix flake update
nix develop
# Verify tools work
```

### Update Checklist

- [ ] Check changelog for breaking changes
- [ ] Update version in dependency file
- [ ] Download/install new version
- [ ] Run full test suite
- [ ] Test manually (especially for vendor libs)
- [ ] Update documentation if API changed
- [ ] Commit with clear message
- [ ] Monitor for issues

## Dependency Health

### Regular Checks

**Monthly review**:
- Check for security advisories
- Review update notifications
- Test with latest compatible versions
- Remove unused dependencies

**Before major releases**:
- Update all dependencies
- Run comprehensive tests
- Document any changes
- Verify compatibility

### Health Indicators

**Healthy dependency**:
- Regular updates (monthly or better)
- Active issue responses
- Good documentation
- Stable API
- Compatible with current Elm

**Unhealthy dependency**:
- No updates in >1 year
- Unresolved security issues
- Breaking API changes
- Incompatible with Elm 0.19.1
- Abandoned project

### Replacement Strategy

If dependency becomes unhealthy:

1. **Evaluate alternatives**: Research other packages
2. **Assess effort**: Switching cost vs risk
3. **Plan migration**: Create migration checklist
4. **Implement gradually**: Feature-flagged if possible
5. **Test thoroughly**: Ensure parity
6. **Document changes**: Update all docs

## License Compliance

### License Summary

All dependencies are BSD-3-Clause or MIT licensed:
- **Elm packages**: BSD-3-Clause
- **PptxGenJS**: MIT
- **JSZip**: MIT (we chose MIT option of dual-license)

### Compliance Requirements

- ✅ Include license notices (vendor files include them)
- ✅ Permit commercial use (all are permissive)
- ✅ Permit modification (all allow it)
- ✅ No copyleft requirements (none have viral licenses)

### Attribution

Vendor libraries include license headers in their source files. No additional attribution required for permissive licenses, but recommended:

```html
<!-- In index.html -->
<!-- Uses PptxGenJS (MIT) and JSZip (MIT) -->
```

## Security Considerations

### Dependency Security

**Elm packages**:
- Vetted by Elm package system
- Pure functional code (no side effects)
- Type-safe (many vulnerabilities prevented by type system)
- No eval or dynamic code execution

**Vendor libraries**:
- Downloaded from reputable CDNs (jsDelivr, cdnjs)
- Pinned to specific versions
- Served locally (not loaded from CDN at runtime)
- Should be reviewed before updating

### Security Best Practices

1. **Pin versions**: Never use `@latest` or unversioned URLs
2. **Use HTTPS**: Always use HTTPS for downloads
3. **Verify integrity**: Consider using subresource integrity (SRI)
4. **Review updates**: Check changelogs for security notes
5. **Minimize attack surface**: Fewer dependencies = fewer risks

### Security Monitoring

- Monitor npm security advisories for vendor libs
- Watch Elm package forums for security discussions
- Subscribe to security mailing lists if available
- Use GitHub Dependabot alerts (if enabled)

## Troubleshooting

### Elm Compilation Errors

**Symptom**: Missing dependencies

**Solution**:
```bash
elm install <package>
```

**Symptom**: Version conflicts

**Solution**:
```bash
# Check constraints
cat elm.json
# May need to update other packages
```

### Vendor Library Issues

**Symptom**: `PptxGenJS is not defined` or `JSZip is not defined`

**Solution**:
```bash
make vendor
# Or force re-download
rm -rf vendor && make vendor
```

**Symptom**: Download fails

**Solution**:
- Check internet connection
- Try different CDN URL
- Download manually and place in vendor/

### Development Tool Issues

**Symptom**: Tool not found in PATH

**Solution**:
```bash
# Exit and re-enter nix shell
exit
nix develop
```

**Symptom**: Version mismatch

**Solution**:
```bash
nix flake update
nix develop
```

## Future Considerations

### Potential Additions

**Note**: Internationalization (I18n) is already implemented using a custom solution in `src/I18n.elm` without external dependencies.

**Advanced Features**:
- elm-ui: Alternative UI framework (if CSS becomes limiting)
- elm-animator: Animations (if transition effects needed)

### Removal Candidates

Currently no dependencies are candidates for removal. All serve clear purposes.

## See Also

- [Build and Development Documentation](./build-and-dev.md)
- [Architecture Documentation](./architecture.md)
- [Testing Documentation](./testing.md)
- [Workflow Documentation](./workflow.md)
- [Main Agent Index](../AGENTS.md)

## Maintenance Notes

Update this document when:
- Dependencies are added, updated, or removed
- Vendor libraries are changed
- Development tools are added
- Dependency strategy evolves
- Security considerations change
- License compliance requirements change
