# Architecture Documentation

**Purpose**: Core architecture patterns, data model, message flow, and view organization for the bullets presentation tool

**Last Updated**: 2025-12-17 (commit 494f4b4)

## Overview

The bullets application follows the Elm Architecture pattern with a Model-View-Update cycle. The application has two primary modes (Edit and Present) with clear separation of concerns between data, view, and business logic.

## Architecture Patterns

### Elm Architecture (MVU)

The application follows the standard Elm Architecture:
- **Model**: Application state (current slide, presentation data, edit mode)
- **View**: Pure functions that render Model to HTML
- **Update**: Pure functions that transform Model based on Messages
- **Subscriptions**: External events (keyboard, localStorage)

### Module Organization

```
src/
├── Main.elm              # Application entry, init, subscriptions
├── Types.elm             # All type definitions and Model
├── Ports.elm             # JavaScript interop ports
├── Json.elm              # JSON encoders/decoders for persistence
├── Navigation.elm        # Slide navigation logic
├── SlideManipulation.elm # Slide operations (add, delete, move, etc.)
├── MarkdownView.elm      # Markdown rendering helper
├── I18n.elm              # Internationalization (main module)
├── I18n/                 # Language-specific translation modules
│   ├── En.elm            # English translations
│   └── Fi.elm            # Finnish translations
├── Update.elm            # Main update coordinator
├── Update/               # Modular update sub-modules
│   ├── Content.elm       # Content editing logic
│   ├── FileIO.elm        # PowerPoint import/export
│   ├── Image.elm         # Image handling logic
│   ├── Keyboard.elm      # Keyboard event routing
│   ├── Mode.elm          # Mode switching logic
│   ├── Navigation.elm    # Navigation updates
│   ├── Slide.elm         # Slide manipulation updates
│   ├── Storage.elm       # Local storage operations
│   └── UI.elm            # UI state (help dialog, language)
└── View/
    ├── Edit.elm          # Edit mode view
    ├── Present.elm       # Presentation mode view
    └── HelpDialog.elm    # Help dialog component
```

### Port-Based JavaScript Interop

The application uses Elm ports for JavaScript interop:
- **localStorage** - Save/load presentations
- **image handling** - Paste and upload images as data URIs
- **PPTX import/export** - PowerPoint file conversion using JSZip and PptxGenJS

### Modular Update Architecture

The update logic is organized into specialized modules for maintainability:

**Update.elm**: Main coordinator that routes messages to appropriate sub-modules

**Sub-modules** (single responsibility principle):
- **Update.Navigation**: Slide navigation (NextSlide, PrevSlide, GoToSlide, FirstSlide, LastSlide)
- **Update.Mode**: Mode switching (EnterPresentMode, ExitPresentMode)
- **Update.Content**: Content editing (UpdateContent, UpdateTitle)
- **Update.Storage**: Local storage operations (LocalStorageLoaded, LanguageLoaded)
- **Update.Image**: Image handling (paste, upload, load, remove)
- **Update.Slide**: Slide manipulation (add, delete, duplicate, move, drag-drop)
- **Update.FileIO**: PowerPoint import/export (ExportToPPTX, ImportPPTXRequested, PPTXImported)
- **Update.UI**: UI state (help dialog, language, textarea focus)
- **Update.Keyboard**: Keyboard event routing (KeyPressed, delegates to other modules)

**Benefits**:
- Each module has single, clear responsibility
- 146 unit tests covering all update logic
- Easy to locate specific functionality
- Adding new features doesn't bloat Main.elm
- Main.elm reduced from 810 lines to 124 lines (85% reduction)

## Data Model

### Core Types

**Slide**: Individual presentation slide
```elm
type alias Slide =
    { content : String      -- Markdown content
    , image : Maybe String  -- Optional image as data URI
    }
```

**Presentation**: Complete presentation
```elm
type alias Presentation =
    { slides : List Slide
    , title : String
    , author : String
    , created : String
    }
```

**Mode**: Application mode
```elm
type Mode
    = Edit
    | Present
```

**Model**: Application state
```elm
type alias Model =
    { mode : Mode
    , currentSlideIndex : Int
    , presentation : Presentation
    , editingContent : String        -- Buffer for current edits
    , draggedSlideIndex : Maybe Int  -- For drag and drop
    , dropTargetIndex : Maybe Int    -- Visual placeholder during drag
    , language : Language            -- UI language (English | Finnish)
    , showHelpDialog : Bool          -- Help dialog visibility
    }
```

### Layout Detection

Slides automatically determine their layout based on content:
- **Title Slide**: Slide 0 (first slide)
- **Content Slide**: Has markdown content, no image
- **Split Slide**: Has both markdown content and image
- **Image Slide**: Has only image, no markdown content

No manual layout selection is needed - the layout is inferred from the data.

## Message Types

### Navigation Messages
- `NextSlide` - Move to next slide
- `PrevSlide` - Move to previous slide  
- `GoToSlide Int` - Jump to specific slide
- `FirstSlide` - Go to first slide
- `LastSlide` - Go to last slide

### Mode Switching
- `EnterPresentMode` - Switch to presentation mode
- `ExitPresentMode` - Return to edit mode

### Slide Management
- `AddSlide` - Create new blank slide
- `DeleteSlide Int` - Remove slide at index
- `DuplicateSlide Int` - Copy slide at index
- `MoveSlideUp Int` - Move slide up in order
- `MoveSlideDown Int` - Move slide down in order

### Drag and Drop
- `DragStart Int` - Begin dragging slide
- `DragOver Int` - Hovering over drop target
- `DragEnd` - Dragging ended
- `Drop Int` - Drop slide at target

### Content Editing
- `UpdateContent String` - Update current slide content
- `UpdateTitle String` - Update presentation title

### Image Handling
- `ImagePasted String` - Image pasted from clipboard (data URI)
- `ImageUploadRequested` - User clicked upload button
- `ImageFileSelected File` - File selected from picker
- `ImageFileLoaded String` - File loaded as data URI
- `RemoveImage` - Remove image from current slide

### File Operations
- `ImportPPTXRequested` - User clicked import button
- `PPTXFileSelected File` - PPTX file selected
- `PPTXLoaded String` - PPTX parsed as JSON
- `ExportToPPTX` - Export to PowerPoint format

### Keyboard Input
- `KeyPressed String Bool Bool` - Handle keyboard shortcuts (key, ctrl, shift)

### Storage
- `LocalStorageLoaded String` - Presentation loaded from localStorage
- `LanguageLoaded String` - UI language loaded from localStorage

### UI State
- `ToggleHelpDialog` - Show/hide help dialog
- `ChangeLanguage Language` - Change UI language
- `TextareaFocused` - Textarea received focus
- `TextareaBlurred` - Textarea lost focus

## View Organization

### Edit Mode (View.Edit)

Structure:
```
┌─────────────────────────────────────────┐
│ Sidebar          │ Main Area            │
│ ┌─────────────┐ │ ┌─────────────────┐  │
│ │ Slide List  │ │ │ Editor          │  │
│ │  - Thumb 1  │ │ │  (textarea)     │  │
│ │  - Thumb 2  │ │ │                 │  │
│ │  - ...      │ │ └─────────────────┘  │
│ └─────────────┘ │ ┌─────────────────┐  │
│ ┌─────────────┐ │ │ Preview         │  │
│ │ Add Button  │ │ │  (rendered)     │  │
│ │ Import/Exp  │ │ │                 │  │
│ └─────────────┘ │ └─────────────────┘  │
└─────────────────────────────────────────┘
```

Components:
- **Sidebar**: Slide navigation toolbar with thumbnails
- **Slide Items**: Draggable items with navigation buttons
- **Editor**: Textarea for markdown editing
- **Preview**: Live markdown rendering
- **Action Buttons**: Add, Import, Export, Present

Features:
- Drag and drop reordering with visual placeholder
- Live markdown preview
- Image thumbnails in slide list
- VIM-style keyboard navigation (disabled while typing)

### Presentation Mode (View.Present)

Structure:
```
┌─────────────────────────────────────────┐
│                                         │
│                                         │
│        Slide Content (centered)         │
│                                         │
│        • Left-aligned text              │
│        • Markdown rendered              │
│        • Images displayed               │
│                                         │
│                                         │
└─────────────────────────────────────────┘
```

Features:
- Full-screen display (beige background)
- Layout-specific rendering
- All content left-aligned (no centering)
- Keyboard navigation (arrows, space, j/k/h/l, g/G, ESC)

### Shared Components

**MarkdownView**: Provides `renderMarkdown` function
- Converts markdown string to HTML
- Uses dillonkearns/elm-markdown
- Shared between edit preview and presentation modes

## Message Flow

### User Action Flow

1. **User Input** → Message
   - Keyboard press → `KeyPressed`
   - Button click → Specific action message
   - File selection → File message

2. **Message** → Update Function
   - Pure transformation of Model
   - May produce Cmd for side effects

3. **Updated Model** → View Function
   - Pure rendering based on new state
   - No side effects in view

4. **View** → DOM
   - Elm runtime handles efficient updates

### Side Effect Flow

1. **Update produces Cmd**
   - Port command sent to JavaScript
   - Example: `exportToPPTX` port

2. **JavaScript processes**
   - External library interaction
   - File system operations

3. **Result sent back via Port**
   - Subscription receives data
   - Example: `pptxLoaded` subscription

4. **Port Message** → Update
   - Cycle continues with new data

## Key Design Decisions

### Automatic Layout Detection
- No manual layout selector needed
- Layout inferred from content structure
- Simplifies user experience
- Reduces UI complexity

### Data URI for Images
- Images stored as base64 data URIs
- No external file dependencies
- Enables easy copy-paste workflow
- All data self-contained in JSON

### Port-Based Architecture
- Clean separation of Elm and JavaScript
- Type-safe boundaries
- Enables use of JS ecosystem (JSZip, PptxGenJS)
- Maintainable interop layer

### Two-Mode Design
- Clear separation: Edit vs Present
- Different keyboard shortcuts per mode
- Focused user experience
- No mode confusion

### VIM-Style Keybindings
- Power user efficiency
- Keyboard-first workflow
- Familiar patterns for developers
- Consistent with terminal habits

### Internationalization (i18n)
- Type-safe translation system via modular I18n structure
- Language union type (English | Finnish) for compile-time safety
- Language-specific modules (I18n/En.elm, I18n/Fi.elm) for maintainability
- Language preference persisted to localStorage
- Easy to add new languages: create new module, update main I18n.elm
- All UI text translated, not user content

### Accessibility (WCAG 2.1 AA)
- Full keyboard navigation support
- ARIA labels and semantic HTML
- Screen reader announcements for state changes
- Help dialog with all keyboard shortcuts
- Visible focus indicators
- High contrast theme

## State Management

### Local State
- All state in single Model
- No component-level state
- Predictable updates
- Easy to test and reason about

### Persistence
- Auto-save to localStorage after each change
- Auto-load on application start
- No manual save/load needed
- Backup via JSON export available

### Undo/Redo
- Not currently implemented
- Could be added via command pattern
- Would require Model history stack

## Performance Considerations

### Rendering
- Virtual DOM diffing by Elm runtime
- Efficient updates for large slide decks
- Markdown parsing cached by library
- Image data URIs loaded once

### Data Size
- Large presentations can grow with images
- Base64 encoding increases size ~33%
- localStorage has 5-10MB limits
- Consider compression for very large decks

## See Also

- [Data Model Documentation](./data-model.md) - Detailed type definitions
- [UI Components Documentation](./ui-components.md) - View implementation details
- [Testing Documentation](./testing.md) - Testing strategy and patterns

## Maintenance Notes

- Update when adding new Message types
- Update when adding new Model fields
- Update when changing module organization
- Keep view organization diagrams current
- Document new architectural patterns as they emerge
