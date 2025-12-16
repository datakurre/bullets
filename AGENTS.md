# AGENTS.md

## Project Overview

**bullets** is a browser-based presentation tool built with Elm. It provides two main modes:
- **Edit Mode**: Create and manage slides with markdown content
- **Presentation Mode**: Display slides in full-screen

## Implementation Status

✅ **COMPLETED** - All core features and vision items have been implemented:
- Edit mode with slide management (add, delete, duplicate, reorder)
- Drag and drop slide arrangement
- Arrow key navigation in edit mode
- Three slide layouts (JustMarkdown, MarkdownWithImage)
- Presentation mode with keyboard navigation
- Image paste support via clipboard AND file upload
- JSON import/export
- PowerPoint PPTX export functionality
- Local storage autosave/autoload
- Complete CSS styling with clean left-aligned design
- Markdown rendering in both preview and presentation modes
- VIM-style keybindings (j/k/arrow navigation, g/G, p for present)
- Keyboard shortcuts disabled while editing in textarea
- GitHub Pages deployment workflow with test coverage
- Comprehensive unit test suite (72 tests)
- elm-review integration for code quality

Recent commits:
- 4807bd5: Add test coverage to GitHub Actions workflow
- e0f8b5e: Fix PPTX export empty slides by matching layout string format
- 3c00643: Add PowerPoint PPTX export functionality
- ad66a2b: Disable keyboard shortcuts while editing in textarea
- c22fa1b: Add arrow key navigation in edit mode for slide selection

## Current Features

### Edit Mode
- Sidebar with slide list and thumbnails
- Add, delete, duplicate, and reorder slides (via buttons or drag & drop)
- Two layout options: Markdown, Markdown + Image
- Live markdown preview
- Image support: paste from clipboard or upload from filesystem
- Auto-save to browser local storage
- Export to JSON file
- Import from JSON file
- VIM-style navigation: j/k for next/prev slide, g/G for first/last, p for present
- Arrow key navigation: Up/Down arrows for next/prev slide
- Keyboard shortcuts disabled while typing in textarea
- Export to PowerPoint PPTX format

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
- Supports multiple slide layouts (markdown, markdown with image)
- Handles images via copy-paste (stored as data URIs)
- Allows import/export of presentations as JSON
- Exports presentations to PowerPoint PPTX format
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
- layout: SlideLayout
- image: Maybe String (data URI)

**SlideLayout**: Two variants
- JustMarkdown: Full-width markdown content
- MarkdownWithImage: Split view (markdown left, image right)

**Presentation**: Complete presentation
- slides: List Slide
- metadata: Title, author, created date

**Model**: Application state
- mode: Mode (Edit | Present)
- currentSlideIndex: Int
- presentation: Presentation
- editingContent: String (buffer for current edits)
- draggedSlideIndex: Maybe Int (for drag and drop)

### Message Types

- Navigation: NextSlide, PrevSlide, GoToSlide Int
- Mode switching: EnterPresentMode, ExitPresentMode
- Slide management: AddSlide, DeleteSlide Int, DuplicateSlide Int, MoveSlideUp Int, MoveSlideDown Int
- Drag and drop: DragStart Int, DragOver, DragEnd, Drop Int
- Content editing: UpdateContent String, ChangeLayout SlideLayout
- Image handling: ImagePasted String, ImageUploadRequested, ImageFileSelected File, ImageFileLoaded String, RemoveImage
- File operations: DownloadJSON, LoadJSONRequested, FileSelected File, FileLoaded String
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
