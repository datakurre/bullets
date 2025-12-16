# Data Model Documentation

**Purpose**: Detailed documentation of all types, data structures, JSON encoding/decoding, and data transformation logic for the bullets presentation tool

**Last Updated**: 2024-12-16 (commit 8a35bf9)

## Overview

The bullets application uses a simple, hierarchical data model built on Elm's type system. All data is strongly typed and immutable. The core data flows from Slide → Presentation → Model, with JSON serialization for persistence.

## Core Data Types

### Slide

Represents a single presentation slide with optional image.

```elm
type alias Slide =
    { content : String      -- Markdown content
    , image : Maybe String  -- Optional image as data URI
    }
```

**Fields:**
- `content`: Markdown-formatted text content for the slide
- `image`: Optional image stored as base64 data URI (e.g., `"data:image/png;base64,..."`)

**Characteristics:**
- Content is always present (can be empty string)
- Image is optional (Nothing means no image)
- No explicit layout field - layout is inferred from content/image presence

**Layout Inference:**
- Title Slide: First slide (index 0)
- Content Slide: Has markdown content, no image
- Split Slide: Has both content and image
- Image Slide: Has image, content is empty or whitespace only

**Initial Value:**
```elm
initialSlide : Slide
initialSlide =
    { content = "# Welcome to Bullets\n\nA minimal presentation tool"
    , image = Nothing
    }
```

### Presentation

Represents a complete presentation with metadata.

```elm
type alias Presentation =
    { slides : List Slide  -- Ordered list of slides
    , title : String       -- Presentation title
    , author : String      -- Author name
    , created : String     -- Creation timestamp
    }
```

**Fields:**
- `slides`: Ordered list of slides (minimum 1 slide)
- `title`: Presentation title (defaults to "Untitled Presentation")
- `author`: Author name (can be empty)
- `created`: Creation timestamp string (can be empty)

**Invariants:**
- Always has at least one slide
- Slide order matters (index-based navigation)
- Metadata is optional but structure is always present

**Initial Value:**
```elm
initialPresentation : Presentation
initialPresentation =
    { slides = [ initialSlide ]
    , title = "Untitled Presentation"
    , author = ""
    , created = ""
    }
```

### Mode

Application mode enumeration.

```elm
type Mode
    = Edit      -- Editing mode with sidebar and editor
    | Present   -- Presentation mode (full-screen)
```

**States:**
- `Edit`: User can edit slides, reorder, add/delete
- `Present`: Full-screen presentation view, read-only

**Transitions:**
- Edit → Present: Via "Present" button or `p` key
- Present → Edit: Via ESC key or exit command

### Model

Complete application state.

```elm
type alias Model =
    { mode : Mode                       -- Current application mode
    , currentSlideIndex : Int           -- Active slide index (0-based)
    , presentation : Presentation       -- Presentation data
    , editingContent : String           -- Buffer for current slide edits
    , draggedSlideIndex : Maybe Int     -- Slide being dragged (drag & drop)
    , dropTargetIndex : Maybe Int       -- Target position for drop
    , isTextareaFocused : Bool          -- Is editor textarea focused
    , showHelpDialog : Bool             -- Is help dialog visible
    }
```

**Fields:**

**Navigation:**
- `mode`: Controls which view is shown
- `currentSlideIndex`: Index of currently displayed/edited slide (0-based)

**Data:**
- `presentation`: The actual presentation data
- `editingContent`: Temporary buffer for unsaved edits to current slide content

**Interaction State:**
- `draggedSlideIndex`: Tracks which slide is being dragged (Nothing when not dragging)
- `dropTargetIndex`: Tracks hover target during drag (for visual placeholder)
- `isTextareaFocused`: Prevents keyboard shortcuts when typing
- `showHelpDialog`: Controls help dialog visibility

**Initial Value:**
```elm
initialModel : Model
initialModel =
    { mode = Edit
    , currentSlideIndex = 0
    , presentation = initialPresentation
    , editingContent = initialSlide.content
    , draggedSlideIndex = Nothing
    , dropTargetIndex = Nothing
    , isTextareaFocused = False
    , showHelpDialog = False
    }
```

## Message Types

All user actions and system events are represented as messages in the `Msg` type.

```elm
type Msg
    = -- Navigation
      NextSlide
    | PrevSlide
    | GoToSlide Int
    
    | -- Mode Management
      EnterPresentMode
    | ExitPresentMode
    
    | -- Slide Management
      AddSlide
    | DeleteSlide Int
    | DuplicateSlide Int
    | MoveSlideUp Int
    | MoveSlideDown Int
    
    | -- Drag and Drop
      DragStart Int
    | DragOver Int
    | DragEnd
    | Drop Int
    
    | -- Content Editing
      UpdateContent String
    
    | -- Image Management
      ImagePasted String
    | ImageUploadRequested
    | ImageFileSelected File
    | ImageFileLoaded String
    | RemoveImage
    
    | -- File Operations
      ExportToPPTX
    | ImportPPTXRequested
    | PPTXImported String
    
    | -- Input Events
      KeyPressed String
    | TextareaFocused
    | TextareaBlurred
    
    | -- Storage
      LocalStorageLoaded String
    
    | -- UI State
      ToggleHelpDialog
```

**Categories:**

**Navigation Messages:**
- `NextSlide`: Move to next slide (wraps to first)
- `PrevSlide`: Move to previous slide (wraps to last)
- `GoToSlide Int`: Jump to specific slide by index

**Mode Messages:**
- `EnterPresentMode`: Switch to presentation mode
- `ExitPresentMode`: Return to edit mode

**Slide Management:**
- `AddSlide`: Create new blank slide at end
- `DeleteSlide Int`: Remove slide at index
- `DuplicateSlide Int`: Copy slide at index
- `MoveSlideUp Int`: Swap slide with previous
- `MoveSlideDown Int`: Swap slide with next

**Drag and Drop:**
- `DragStart Int`: User starts dragging slide at index
- `DragOver Int`: User drags over target position
- `DragEnd`: Drag operation cancelled
- `Drop Int`: User drops slide at target position

**Content Editing:**
- `UpdateContent String`: Textarea content changed

**Image Management:**
- `ImagePasted String`: Image pasted from clipboard (data URI)
- `ImageUploadRequested`: User clicked upload button
- `ImageFileSelected File`: File picker returned file
- `ImageFileLoaded String`: File read as data URI
- `RemoveImage`: Remove image from current slide

**File Operations:**
- `ExportToPPTX`: Export presentation to PowerPoint
- `ImportPPTXRequested`: User clicked import button
- `PPTXImported String`: PPTX parsed as JSON string

**Input Events:**
- `KeyPressed String`: Keyboard key pressed (for shortcuts)
- `TextareaFocused`: Editor textarea gained focus
- `TextareaBlurred`: Editor textarea lost focus

**Storage:**
- `LocalStorageLoaded String`: Presentation loaded from browser storage

**UI State:**
- `ToggleHelpDialog`: Show/hide keyboard shortcuts help

## JSON Serialization

### Encoding

Presentations are encoded to JSON for storage and export.

**Presentation JSON Structure:**
```json
{
  "slides": [
    {
      "content": "# Title\n\nContent here",
      "image": "data:image/png;base64,..." or null
    }
  ],
  "title": "My Presentation",
  "author": "John Doe",
  "created": "2024-12-16"
}
```

**Encoder Implementation:**
```elm
encodePresentation : Presentation -> Encode.Value
encodePresentation presentation =
    Encode.object
        [ ( "slides", Encode.list encodeSlide presentation.slides )
        , ( "title", Encode.string presentation.title )
        , ( "author", Encode.string presentation.author )
        , ( "created", Encode.string presentation.created )
        ]

encodeSlide : Slide -> Encode.Value
encodeSlide slide =
    Encode.object
        [ ( "content", Encode.string slide.content )
        , ( "image"
          , case slide.image of
                Just img -> Encode.string img
                Nothing -> Encode.null
          )
        ]
```

**Characteristics:**
- Images stored as data URIs (base64 encoded)
- Null used for absent images (not missing field)
- All fields always present
- No version field (assumes current format)

### Decoding

JSON is decoded back to Elm types with error handling.

**Decoder Implementation:**
```elm
decodePresentation : Decoder Presentation
decodePresentation =
    Decode.map4 Presentation
        (Decode.field "slides" (Decode.list decodeSlide))
        (Decode.field "title" Decode.string)
        (Decode.field "author" Decode.string)
        (Decode.field "created" Decode.string)

decodeSlide : Decoder Slide
decodeSlide =
    Decode.map2 Slide
        (Decode.field "content" Decode.string)
        (Decode.field "image" (Decode.nullable Decode.string))
```

**Error Handling:**
- Decode failures return `Err` (handled in update function)
- Invalid JSON is silently ignored
- No migration for old formats (would need version field)

**Validation:**
- No explicit validation beyond JSON structure
- Empty presentations are allowed (decoder succeeds)
- Malformed data URIs pass through (validated at render time)

## Data Transformations

### Slide Manipulation

Operations on slide lists are in `SlideManipulation` module.

**Common Operations:**
- Add slide: Append to list
- Delete slide: Filter by index
- Duplicate slide: Insert copy after original
- Move up/down: Swap adjacent slides
- Reorder: Move slide to new index (drag & drop)

**Index Management:**
- All indices are 0-based
- Current slide index updates after operations
- Boundary checks prevent invalid indices

### Image Handling

**Data URI Format:**
```
data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUA...
```

**Sources:**
- Clipboard paste: Via port from JavaScript
- File upload: Read and converted to data URI
- PPTX import: Extracted and converted

**Storage:**
- Stored directly in Slide record
- Included in JSON serialization
- No separate image storage layer

### Layout Detection

Layout is inferred from slide content and image presence:

```elm
-- Pseudocode for layout detection
detectLayout : Int -> Slide -> Layout
detectLayout index slide =
    if index == 0 then
        TitleSlide
    else if hasImage slide && hasContent slide then
        SplitSlide
    else if hasImage slide then
        ImageSlide
    else
        ContentSlide

hasContent : Slide -> Bool
hasContent slide =
    String.trim slide.content
        |> String.isEmpty
        |> not

hasImage : Slide -> Bool
hasImage slide =
    slide.image /= Nothing
```

## Data Flow

### Load Flow
```
Browser Storage → JSON String → Decoder → Presentation → Model
```

### Save Flow
```
Model → Presentation → Encoder → JSON String → Browser Storage
```

### Edit Flow
```
User Input → UpdateContent → editingContent (buffer)
Blur Event → Save to Presentation → Auto-save to Storage
```

### Import Flow
```
PPTX File → JavaScript Port → Parse → JSON → Decoder → Presentation
```

### Export Flow
```
Presentation → Encoder → JSON → JavaScript Port → Generate PPTX → Download
```

## Persistence

### Local Storage

**Auto-save Trigger:**
- After any operation that modifies presentation
- Debounced to prevent excessive saves

**Storage Key:**
- Single key: `"presentation"`
- Overwrites previous version
- No version history

**Load Strategy:**
- Automatic on app initialization
- Fallback to initialPresentation if empty or invalid

### PPTX Export

**Conversion:**
- Presentation → JSON → JavaScript
- JavaScript uses PptxGenJS library
- Images embedded from data URIs
- Markdown converted to text/shapes

**Layout Mapping:**
- Title Slide: Centered title layout
- Content Slide: Left-aligned text
- Split Slide: Half text, half image
- Image Slide: Full-screen image

### PPTX Import

**Conversion:**
- PPTX file → JavaScript (JSZip + XML parsing)
- Extracts text and images
- Images converted to data URIs
- Text preserved as-is (not converted to markdown)

**Limitations:**
- No formatting preservation
- No animations or transitions
- Images extracted as-is
- One slide → one Slide record

## Type Safety

### Elm Type System Benefits

**Compile-time Guarantees:**
- No null pointer exceptions (Maybe type)
- No undefined errors
- All cases handled (exhaustive pattern matching)
- No runtime type errors

**Impossible States:**
- Can't have negative slide index (caught at compile time if using literals)
- Can't have null strings (use empty string)
- Can't have invalid Mode (only Edit or Present)

**Refactoring Safety:**
- Adding Msg variant updates all pattern matches
- Changing Model structure updates all accessors
- Compiler finds all affected code

## Testing Considerations

### Unit Tests

**JSON Round-trip:**
- Encode then decode should equal original
- Test with various slide configurations
- Test with/without images

**Slide Manipulation:**
- Test boundary conditions (empty list, single slide)
- Test index calculations
- Test list operations (add, delete, move, reorder)

**Layout Detection:**
- Test all layout combinations
- Test edge cases (empty content, whitespace)

### Property Tests

**Invariants:**
- Presentation always has ≥ 1 slide
- Current index always valid (0 ≤ index < length)
- JSON round-trip is identity

## See Also

- [Architecture Documentation](./architecture.md) - Overall architecture and message flow
- [UI Components Documentation](./ui-components.md) - View rendering and UI patterns
- [Testing Documentation](./testing.md) - Testing strategy and test organization

## Maintenance Notes

- Update when adding new fields to types
- Update JSON schema examples when changing encoding
- Document new transformation logic
- Keep encoder/decoder in sync
- Test JSON compatibility when making changes
