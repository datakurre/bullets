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
- Comprehensive unit test suite (80 tests)
- elm-review integration for code quality
- **Comprehensive accessibility support (WCAG 2.1 AA)**: ARIA labels, keyboard navigation, focus management, screen reader announcements, help dialog
- **Internationalization (i18n)**: Multi-language support with English and Finnish translations, language selector UI, local storage persistence

Recent commits:
- b3f0c21: Move add-slide button to slide actions
- 7ceb5e0: Fix UI vertical growth by adding min-height constraints
- 7024246: Implement i18n with English and Finnish support
- ab85857: Fix slide navigation scrolling
- 59052b4: Make presentation title editable
- 54500ee: Fix action buttons visibility
- 37bf36d: Fix vertical layout issues

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

## Accessibility (A11y)

**ENFORCE ACCESSIBILITY** for all UI features and interactions following WCAG 2.1 AA guidelines:

### Core Accessibility Features

The application implements comprehensive accessibility support:

#### Semantic HTML and ARIA
- Proper landmark regions: `<nav>`, `<main>`, `<aside>` with appropriate `role` and `aria-label` attributes
- ARIA labels on all interactive buttons for screen reader users
- `role="list"` and `role="listitem"` for slide navigation
- `aria-current="true"` indicates active slide in list
- `role="toolbar"` for button groups
- Live region announcements (`aria-live="polite"`) for:
  - Slide navigation changes
  - Mode transitions (entering/exiting presentation)
  - Slide operations (add, delete, duplicate, reorder)

#### Keyboard Navigation
- **Full keyboard accessibility**: All features available without mouse
- **VIM-style navigation**: j/k for next/prev slide, g/G for first/last, p for present
- **Arrow key navigation**: Up/Down arrows in edit mode, all arrows in present mode
- **Keyboard slide reordering**: Ctrl+Shift+Up/Down to move slides
- **File operations**: Ctrl+O for import, Ctrl+I for image upload, Ctrl+S for export
- **Help dialog**: Press '?' to view all keyboard shortcuts, ESC to close
- **Skip to content link**: Visible on focus, jumps to main content area
- Keyboard shortcuts automatically disabled while editing in textarea

#### Focus Management
- Visible focus indicators on all interactive elements (3px solid outline with sufficient contrast)
- Logical focus order through interactive elements
- Focus indicators styled for both light and dark active states

#### Visual Accessibility
- High-contrast light theme (beige background #f5f5f0, dark text #1a1a1a)
- Consistent focus indicators with 3:1 minimum contrast ratio
- Hover states on all interactive elements for visual feedback
- Visual placeholder during drag and drop operations

### Accessibility Requirements for New Features

When implementing new features, **ALWAYS**:

1. **Keyboard Accessibility**:
   - Ensure all functionality is keyboard-accessible (no mouse-only interactions)
   - Test with Tab, Shift+Tab, Enter, Space, Arrow keys, ESC
   - Add keyboard shortcuts for frequently used actions
   - Disable global shortcuts when user is typing in input fields

2. **Screen Reader Support**:
   - Add appropriate ARIA labels (`aria-label`, `aria-labelledby`)
   - Use semantic HTML elements (button, nav, main, aside)
   - Provide meaningful `role` attributes where needed
   - Announce dynamic changes with live regions (`aria-live`)
   - Set `aria-current` for current/active items

3. **Focus Management**:
   - Ensure logical tab order
   - Add visible focus indicators (`:focus` styles)
   - Use `:focus-visible` for keyboard-only focus indicators
   - Maintain focus context during mode transitions

4. **Visual Design**:
   - Maintain 4.5:1 contrast ratio for normal text
   - Maintain 3:1 contrast ratio for large text and UI components
   - Use more than color alone to convey information
   - Ensure focus indicators are clearly visible

5. **Documentation**:
   - Update help dialog with new keyboard shortcuts
   - Add ARIA attributes to describe new interactive elements
   - Document accessibility testing in TODO-A11Y.md

### Testing Accessibility

For any UI changes:
- **Manual keyboard testing**: Navigate entire interface without mouse
- **Screen reader testing**: Test with NVDA/JAWS (Windows), VoiceOver (macOS), Orca (Linux)
- **Focus indicators**: Verify all interactive elements show clear focus
- **Announcements**: Verify screen reader announces state changes
- **Contrast**: Check color contrast ratios meet WCAG AA standards

### Accessibility Resources

- See TODO-A11Y.md for comprehensive accessibility task tracking
- Phase 1 & 2 core tasks completed (ARIA, keyboard navigation, focus management)
- Ongoing: Phase 3+ (color contrast audit, advanced features, testing)
- Reference: [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- Reference: [ARIA Authoring Practices](https://www.w3.org/WAI/ARIA/apg/)

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
- language: Language (user's selected language)

### Message Types

- Navigation: NextSlide, PrevSlide, GoToSlide Int
- Mode switching: EnterPresentMode, ExitPresentMode
- Slide management: AddSlide, AddSlideAfter Int, DeleteSlide Int, DuplicateSlide Int, MoveSlideUp Int, MoveSlideDown Int
- Drag and drop: DragStart Int, DragOver Int, DragEnd, Drop Int
- Content editing: UpdateContent String, UpdateTitle String
- Image handling: ImagePasted String, ImageUploadRequested, ImageFileSelected File, ImageFileLoaded String, RemoveImage
- File operations: ImportPPTXRequested, PPTXFileSelected File, PPTXLoaded String, ExportToPPTX
- Keyboard: KeyPressed String Bool Bool
- Storage: LocalStorageLoaded String, LanguageLoaded String
- Language: ChangeLanguage Language

### View Organization

- Edit mode: Sidebar (slide list) + Main (editor + preview)
  - View.Edit module handles all edit mode UI
  - Markdown preview with live rendering
- Present mode: Full-screen slide renderer
  - View.Present module handles presentation UI
  - Rendered markdown with layout-specific display
- Shared: MarkdownView module provides markdown rendering helper

### Internationalization (i18n)

**Language Support**: Currently supports English (default) and Finnish.

**Architecture**:
- `I18n` module provides type-safe translation system
- `Language` union type (English | Finnish) for compile-time safety
- `Translations` record type ensures all translations present
- Language preference persisted to local storage

**Translation Pattern**:
```elm
let
    t = I18n.translations model.language
in
    button [] [ text t.addSlide ]
```

**How to Add a New Language**:
1. Add variant to `Language` type in `src/I18n.elm`
2. Add translation function for the new language (follow `english` or `finnish` pattern)
3. Update `translations` function to handle new language
4. Add encoding/decoding support in `encodeLanguage` and `decodeLanguage`
5. Update language selector in `View.Edit.viewLanguageSelector`
6. Add new option to the dropdown with appropriate label

**Translation Key Naming**:
- Use camelCase for translation keys
- Group related translations (e.g., `addSlide`, `deleteSlide`)
- Use descriptive names that indicate UI context
- Keep ARIA label keys explicit (e.g., `moveSlideUp` vs `moveSlideUpLabel`)

**Storage**:
- Language preference stored separately from presentation data
- Key: `LANGUAGE_KEY` in localStorage
- Automatically loaded on app initialization
- Changes saved immediately when user switches language

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
- 80 unit tests covering core functionality
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
- All tests pass: 80 unit tests currently in test suite

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
