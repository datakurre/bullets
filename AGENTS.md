# AGENTS.md

## Project Overview

**bullets** is a browser-based presentation tool built with Elm. It provides two main modes:
- **Edit Mode**: Create and manage slides with markdown content
- **Presentation Mode**: Display slides in full-screen

## Vision

A minimal, elegant presentation tool that:
- Uses markdown for content authoring
- Supports multiple slide layouts (title only, markdown, markdown with image)
- Handles images via copy-paste (stored as data URIs)
- Allows import/export of presentations as JSON
- Features a clean black-on-off-white color scheme

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

The project will use a Makefile with these targets:
- `make init` - Initialize project dependencies
- `make watch` - Development mode with auto-reload
- `make build` - Production build
- `make test` - Run test suite
- `make format` - Format all source files
- `make clean` - Remove build artifacts

## Architecture (Planned)

### Data Model

**Slide**: Individual presentation slide
- content: String (markdown)
- layout: SlideLayout
- image: Maybe String (data URI)

**SlideLayout**: Three variants
- TitleOnly: Large centered title
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

### Message Types

- Navigation: NextSlide, PrevSlide, GoToSlide Int
- Mode switching: EnterPresentMode, ExitPresentMode
- Slide management: AddSlide, DeleteSlide, DuplicateSlide, ReorderSlide
- Content editing: UpdateContent String, ChangeLayout SlideLayout
- Image handling: ImagePasted String, RemoveImage
- File operations: DownloadJSON, LoadJSON, FileSelected File

### View Organization

- Edit mode: Sidebar (slide list) + Main (editor + preview)
- Present mode: Full-screen slide renderer
- Shared: Markdown renderer component

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
- Manual testing for UI interactions
- Cross-browser testing before major releases
- Focus on data integrity (JSON round-trip correctness)

## Dependencies (Planned)

Core:
- elm/browser - Application framework
- elm/json - JSON encoding/decoding
- elm/html - View rendering

Markdown:
- dillonkearns/elm-markdown or pablohirafuji/elm-markdown

File handling:
- elm/file - File upload/download

## Notes for LLM Agents

- TODO.md contains the task queue - work through items sequentially
- This file (AGENTS.md) is for agent documentation - keep it updated
- Test each change before committing
- Never commit TODO.md
- Don't chain shell commands with && (as per TODO.md instructions)
- Each commit should represent one complete task
- Use the existing nix flake environment for all operations
