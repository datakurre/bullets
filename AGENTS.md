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
- Comprehensive unit test suite (72 tests)
- elm-review integration for code quality

Recent commits:
- 03dabf8: Center icons in slide-item buttons
- bad5c49: Show image thumbnails in slide navigation toolbar
- a76783c: Add TDD enforcement documentation to AGENTS.md
- 387a41d: Add visual placeholder for drag and drop - Phase 2
- d22680b: Add drop target tracking for drag and drop - Phase 1
- 91e9b32: Remove layout selector and automatically determine layout
- a020265: Remove Load and Save JSON actions

## Current Features

### Edit Mode
- Sidebar with slide list and image thumbnails
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

## Development Environment

The project uses Nix flakes for reproducible development environment:
- Elm compiler and core tools
- elm-format for code formatting
- elm-test for unit testing  
- elm-review for code quality
- elm-live for development server
- Node.js for tooling support

Enter dev environment: `nix develop`

## Build System

The project uses a Makefile with these targets:
- `make init` - Initialize project dependencies
- `make watch` - Development mode with auto-reload (uses elm-live)
- `make build` - Production build with optimization
- `make test` - Run test suite
- `make format` - Format all source files with elm-format
- `make clean` - Remove build artifacts

## Architecture

### Data Model

**Slide**: Individual presentation slide
- content: String (markdown)
- image: Maybe String (data URI)

**Presentation**: Complete presentation
- slides: List Slide
- title: String
- author: String
- created: String

**Model**: Application state
- mode: Mode (Edit | Present)
- currentSlideIndex: Int
- presentation: Presentation
- editingContent: String (buffer for current edits)
- draggedSlideIndex: Maybe Int (for drag and drop)
- dropTargetIndex: Maybe Int (for visual placeholder)

### Message Types

- Navigation: NextSlide, PrevSlide, GoToSlide Int
- Mode switching: EnterPresentMode, ExitPresentMode
- Slide management: AddSlide, DeleteSlide Int, DuplicateSlide Int, MoveSlideUp Int, MoveSlideDown Int
- Drag and drop: DragStart Int, DragOver Int, DragEnd, Drop Int
- Content editing: UpdateContent String
- Image handling: ImagePasted String, ImageUploadRequested, ImageFileSelected File, ImageFileLoaded String, RemoveImage
- File operations: ImportPPTXRequested, PPTXFileSelected File, PPTXLoaded String, ExportToPPTX
- Keyboard: KeyPressed String
- Storage: LocalStorageLoaded String

### View Organization

- Edit mode: Sidebar (slide list) + Main (editor + preview)
  - View.Edit module handles all edit mode UI
  - Markdown preview with live rendering
- Present mode: Full-screen slide renderer
  - View.Present module handles presentation UI
  - Rendered markdown with layout-specific display
- Shared: MarkdownView module provides markdown rendering helper

## Development Workflow

1. Check TODO.md for current tasks
2. Work on one task at a time
3. Test changes (unit tests or manual verification)
4. Format code: `make format`
5. Commit with descriptive message
6. Mark task as complete in TODO.md with commit hash
7. Do NOT commit TODO.md itself

## Test-Driven Development (TDD)

**ENFORCE TDD** for all new features and bug fixes that involve business logic:

### TDD Workflow
1. **Write the test first**: Before implementing any new logic, write a failing test that describes the desired behavior
2. **Run tests to confirm failure**: Verify the test fails for the right reason (`make test`)
3. **Implement the minimal code**: Write just enough code to make the test pass
4. **Run tests to confirm success**: Verify all tests pass (`make test`)
5. **Refactor if needed**: Improve the code while keeping tests green
6. **Format code**: Run `make format` before committing

### When to Apply TDD
- **ALWAYS** for pure functions (encoders, decoders, transformations, utilities)
- **ALWAYS** for business logic (slide manipulation, navigation logic, data validation)
- **ALWAYS** for bug fixes (write a test that reproduces the bug first)
- UI changes may be tested manually if unit testing is impractical

### Test Organization
- Place tests in `tests/` directory matching source module names
- Group related tests using `describe` blocks
- Use descriptive test names that explain what is being tested
- Each test should focus on one specific behavior
- Maintain high test coverage for critical paths

### Current Test Coverage
- 72 unit tests covering core functionality
- Focus areas: JSON serialization, navigation logic, slide manipulation
- Run `make coverage` to generate HTML coverage report

## Code Style

- Use elm-format standard formatting
- Prefer explicit type annotations
- Keep functions small and focused
- Use descriptive names for types and functions
- Group related functions together
- Add comments for complex logic only

## Testing Strategy

- Unit tests for pure functions (encoders, decoders, transformations)
- Manual testing for UI interactions (documented in MANUAL_TESTING.md)
- Cross-browser testing before major releases
- Focus on data integrity (JSON round-trip correctness)
- Run elm-review for code quality checks
- All tests pass: 72 unit tests currently in test suite

## Dependencies

Core:
- elm/browser - Application framework
- elm/json - JSON encoding/decoding
- elm/html - View rendering
- elm/file - File upload/download

Markdown:
- dillonkearns/elm-markdown - Markdown parsing and rendering with custom renderer support

## Notes for LLM Agents

- TODO.md contains the task queue - work through items sequentially
- This file (AGENTS.md) is for agent documentation - keep it updated
- Test each change before committing
- Never commit TODO.md
- Don't chain shell commands with && (as per TODO.md instructions)
- Each commit should represent one complete task
- Use the existing nix flake environment for all operations
