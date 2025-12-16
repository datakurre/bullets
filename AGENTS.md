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

Recent commits:
<<<<<<< HEAD
- 38a25ed: Migrate Main.elm to use Update.elm coordinator (85% size reduction)
- 410beda: Create Update.elm coordinator module
- 8ea82f6: Create Update.Keyboard module
- debf815: Create Update.UI module with TDD tests
- 1b5fe64: Create Update.FileIO module with TDD tests
- 12b571d: Create Update.Slide module with comprehensive TDD tests
- 9d8ec30: Create Update.Image module with TDD tests
- 876ce9f: Create Update.Content module with TDD tests
- 2b6a776: Create Update.Storage module with TDD tests
- 73ea52c: Create Update.Mode module with TDD tests
- 1d93711: Create Update.Navigation module with TDD tests
=======
- 715297d: Add agents/dependencies.md - Phase 8 of refactor
- 70150f6: Add agents/workflow.md - Phase 7 of refactor
- 479ff4b: Add agents/testing.md - Phase 6 of refactor
- 2e3fbf4: Add agents/build-and-dev.md - Phase 5 of refactor
- 6df20c7: Increase thumbnail size by 1.5x (60x45 -> 90x68)
- 03dabf8: Center icons in slide-item buttons
- bad5c49: Show image thumbnails in slide navigation toolbar
>>>>>>> 49636f6 (Restructure AGENTS.md as index - Phase 9 of refactor)

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

<<<<<<< HEAD
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
=======
## Documentation Index
>>>>>>> 49636f6 (Restructure AGENTS.md as index - Phase 9 of refactor)

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

<<<<<<< HEAD
**Model**: Application state
- mode: Mode (Edit | Present)
- currentSlideIndex: Int
- presentation: Presentation
- editingContent: String (buffer for current edits)
- draggedSlideIndex: Maybe Int (for drag and drop)
- dropTargetIndex: Maybe Int (for visual placeholder)
- language: Language (user's selected language)
=======
### Enter Development Environment
>>>>>>> 49636f6 (Restructure AGENTS.md as index - Phase 9 of refactor)

```bash
nix develop
```

<<<<<<< HEAD
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
=======
### Common Commands
>>>>>>> 49636f6 (Restructure AGENTS.md as index - Phase 9 of refactor)

```bash
make watch    # Development server with hot reload
make build    # Production build
make test     # Run test suite
make format   # Format all Elm files
make coverage # Generate HTML coverage report
make clean    # Remove build artifacts
```

### Key File Locations

<<<<<<< HEAD
### Update Architecture (Modular)

**Update.elm**: Main coordinator module that routes all messages to specialized sub-modules.

**Modular Update Modules** (single responsibility principle):
- **Update.Navigation**: Slide navigation (NextSlide, PrevSlide, GoToSlide)
- **Update.Mode**: Mode switching (EnterPresentMode, ExitPresentMode)
- **Update.Content**: Content editing (UpdateContent, UpdateTitle)
- **Update.Storage**: Local storage operations (LocalStorageLoaded)
- **Update.Image**: Image handling (paste, upload, load, remove)
- **Update.Slide**: Slide manipulation (add, delete, duplicate, move, drag-drop)
- **Update.FileIO**: PowerPoint import/export (ExportToPPTX, ImportPPTXRequested, PPTXImported)
- **Update.UI**: UI state (help dialog, language, textarea focus)
- **Update.Keyboard**: Keyboard event routing (KeyPressed, delegates to other modules)

**Benefits**:
- **Maintainability**: Each module has single, clear responsibility
- **Testability**: 146 unit tests covering all update logic
- **Readability**: Easy to locate specific functionality
- **Scalability**: Adding new features doesn't bloat Main.elm
- **Reduced Main.elm**: From 810 lines to 124 lines (85% reduction)

**Architecture Pattern**:
```elm
-- Main.elm delegates to Update.elm
update = Update.update

-- Update.elm routes to specialized modules
update msg model =
    case msg of
        NextSlide -> Update.Navigation.nextSlide model
        AddSlide -> Update.Slide.addSlide model
        -- ... etc
```

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
=======
```
src/
├── Main.elm              # Application entry point
├── Types.elm             # Core type definitions
├── Json.elm              # JSON encoding/decoding
├── Navigation.elm        # Navigation logic
├── SlideManipulation.elm # Slide operations
├── MarkdownView.elm      # Markdown rendering
├── Ports.elm             # JavaScript interop
└── View/
    ├── Edit.elm          # Edit mode UI
    └── Present.elm       # Presentation mode UI
>>>>>>> 49636f6 (Restructure AGENTS.md as index - Phase 9 of refactor)

tests/
├── JsonTest.elm          # JSON tests
├── NavigationTest.elm    # Navigation tests
└── SlideManipulationTest.elm  # Slide manipulation tests

<<<<<<< HEAD
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
=======
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
>>>>>>> 49636f6 (Restructure AGENTS.md as index - Phase 9 of refactor)

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

