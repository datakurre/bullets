# AGENTS.md

## Project Overview

**bullets** is a browser-based presentation tool built with Elm. It provides two main modes:
- **Edit Mode**: Create and manage slides with markdown content
- **Presentation Mode**: Display slides in full-screen

## Implementation Status

✅ **COMPLETED** - All core features and vision items have been implemented:
- Edit mode with slide management (add, delete, duplicate, reorder)
- Drag and drop slide arrangement with visual placeholder
- Arrow key navigation in edit mode
- Automatic layout detection (no manual layout selector needed)
- Presentation mode with keyboard navigation
- Image paste support via clipboard AND file upload
- PowerPoint PPTX import functionality
- PowerPoint PPTX export functionality
- Local storage autosave/autoload
- Complete CSS styling with clean left-aligned design
- Markdown rendering in both preview and presentation modes
- VIM-style keybindings (j/k/arrow navigation, g/G, p for present)
- Keyboard shortcuts disabled while editing in textarea
- Image thumbnails in slide navigation toolbar
- GitHub Pages deployment workflow with test coverage
- Comprehensive unit test suite (146 tests)
- elm-review integration for code quality
- **Comprehensive accessibility support (WCAG 2.1 AA)**: ARIA labels, keyboard navigation, focus management, screen reader announcements, help dialog
- **Internationalization (i18n)**: Multi-language support with English and Finnish translations, language selector UI, local storage persistence

## Current Features

### Edit Mode
- Sidebar with slide list and image thumbnails (90x68px)
- Add, delete, duplicate, and reorder slides (via buttons or drag & drop)
- Automatic layout detection based on content
- Live markdown preview
- Image support: paste from clipboard or upload from filesystem
- Auto-save to browser local storage
- Import from PowerPoint PPTX
- Export to PowerPoint PPTX
- VIM-style navigation: j/k for next/prev slide, g/G for first/last, p for present
- Arrow key navigation: Up/Down arrows for next/prev slide
- Keyboard shortcuts disabled while typing in textarea
- Visual placeholder during drag and drop operations

### Presentation Mode
- Clean light-themed display (beige background)
- Rendered markdown (not source)
- Layout-specific rendering
- All content left-aligned (no centering)
- Image display for split layouts
- Multiple navigation options: arrows, space, enter, j/k/h/l
- VIM-style shortcuts: g for first slide, G for last slide
- ESC to exit

## Vision

A minimal, elegant presentation tool that:
- Uses markdown for content authoring
- Automatically detects slide layout based on content
- Handles images via copy-paste (stored as data URIs)
- Allows import/export of presentations as PowerPoint PPTX
- Features a clean left-aligned design with consistent styling

✅ **All vision items are now implemented!**

## Documentation Index

Detailed documentation is organized into focused topic areas:

### Core Documentation

- **[Architecture](./agents/architecture.md)** - Data model, message types, view organization, and overall system design
- **[Data Model](./agents/data-model.md)** - Type definitions, JSON encoding/decoding, and data structures
- **[UI Components](./agents/ui-components.md)** - View organization, component hierarchy, and UI patterns

### Development Documentation

- **[Build and Development](./agents/build-and-dev.md)** - Nix environment, Makefile, development server, CI/CD pipeline
- **[Testing](./agents/testing.md)** - TDD workflow, test organization, coverage reporting, manual testing
- **[Workflow](./agents/workflow.md)** - Development process, commit conventions, task management
- **[Dependencies](./agents/dependencies.md)** - Elm packages, vendor libraries, development tools

### Decision Records

- **[ADR Directory](./agents/adr/)** - Architecture Decision Records documenting key technical choices
  - [001: VIM Keybindings](./agents/adr/001-vim-keybindings.md)

## Quick Start

### Enter Development Environment

```bash
nix develop
```

### Common Commands

```bash
make watch    # Development server with hot reload
make build    # Production build
make test     # Run test suite
make format   # Format all Elm files
make coverage # Generate HTML coverage report
make clean    # Remove build artifacts
```

### Key File Locations

```
src/
├── Main.elm              # Application entry point
├── Types.elm             # Core type definitions
├── Json.elm              # JSON encoding/decoding
├── Navigation.elm        # Navigation logic
├── SlideManipulation.elm # Slide operations
├── MarkdownView.elm      # Markdown rendering
├── Ports.elm             # JavaScript interop
├── Update.elm            # Main update coordinator
├── I18n.elm              # Internationalization
└── View/
    ├── Edit.elm          # Edit mode UI
    ├── Present.elm       # Presentation mode UI
    └── HelpDialog.elm    # Help dialog

tests/
├── JsonTest.elm          # JSON tests
├── NavigationTest.elm    # Navigation tests
├── SlideManipulationTest.elm  # Slide manipulation tests
└── Update/               # Update module tests

agents/
├── README.md             # Agent docs overview
├── architecture.md       # System architecture
├── data-model.md         # Data structures
├── ui-components.md      # UI organization
├── build-and-dev.md      # Build and development
├── testing.md            # Testing strategy
├── workflow.md           # Development workflow
├── dependencies.md       # Dependencies
└── adr/                  # Architecture decisions
```

## Notes for LLM Agents

- **TODO.md** contains the task queue - work through items sequentially
- **This file (AGENTS.md)** is the agent documentation index - keep it updated
- **Test each change** before committing (see [Testing](./agents/testing.md))
- **Never commit TODO.md** - it's working memory, not repository content
- **Don't chain shell commands** with && (see [Workflow](./agents/workflow.md))
- **Each commit** should represent one complete task
- **Use nix environment** for all operations (see [Build and Development](./agents/build-and-dev.md))
- **Follow TDD** for business logic (see [Testing](./agents/testing.md))

## Agent Workflow Summary

1. Read TODO.md for current tasks
2. Read relevant detailed docs (architecture, testing, etc.)
3. Write test first (if applicable)
4. Implement feature
5. Run tests: `make test`
6. Format code: `make format`
7. Commit with clear message
8. Update TODO.md with commit hash
9. Update agent docs if needed
10. Move to next task

For complete workflow details, see [Workflow Documentation](./agents/workflow.md).
