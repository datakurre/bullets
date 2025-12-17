# UI Components Documentation

**Purpose**: View organization, component breakdown, CSS conventions, and UI implementation patterns for the bullets presentation tool

**Last Updated**: 2025-12-17 (commit c6805ef)

## Overview

The bullets UI follows a two-mode design with completely separate views for editing and presenting. All views are implemented as pure functions using Elm's HTML library. The styling uses plain CSS with a minimalist, left-aligned design philosophy.

## View Architecture

### Module Organization

```
src/
├── Main.elm              # Root view function, app container
├── View/
│   ├── Edit.elm          # Edit mode view
│   ├── Present.elm       # Presentation mode view
│   └── HelpDialog.elm    # Help dialog component
└── MarkdownView.elm      # Shared markdown rendering
```

### Root View (Main.elm)

```elm
view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ case model.mode of
            Edit -> viewEditMode model
            Present -> viewPresentMode model
        , if model.showHelpDialog then
            viewHelpDialog
          else
            text ""
        ]
```

**Responsibilities:**
- Mode switching between edit and present
- Help dialog overlay
- Top-level app container

## Edit Mode Components

### Layout Structure

```
┌─────────────────────────────────────────────────┐
│ edit-mode                                       │
│  ┌──────────────┬───────────────────────────┐  │
│  │ sidebar      │ editor-panel              │  │
│  │              │                           │  │
│  │ ┌──────────┐ │ ┌─────────────────────┐   │  │
│  │ │  header  │ │ │  editor             │   │  │
│  │ │  Slides  │ │ │  (textarea)         │   │  │
│  │ │  + btn   │ │ │                     │   │  │
│  │ └──────────┘ │ └─────────────────────┘   │  │
│  │              │                           │  │
│  │ ┌──────────┐ │ ┌─────────────────────┐   │  │
│  │ │slide-list│ │ │  preview            │   │  │
│  │ │  [1] ... │ │ │  (rendered markdown)│   │  │
│  │ │  [2] ... │ │ │                     │   │  │
│  │ │  [3] ... │ │ │                     │   │  │
│  │ └──────────┘ │ └─────────────────────┘   │  │
│  │              │                           │  │
│  │ ┌──────────┐ │                           │  │
│  │ │  footer  │ │                           │  │
│  │ │ Present  │ │                           │  │
│  │ │ Import   │ │                           │  │
│  │ │ Export   │ │                           │  │
│  │ └──────────┘ │                           │  │
│  └──────────────┴───────────────────────────┘  │
└─────────────────────────────────────────────────┘
```

### Sidebar Component

**viewSidebar : Model -> Html Msg**

Consists of three sections:

1. **Header**: Title + Add button
2. **Slide List**: Scrollable list of slide items
3. **Footer**: Action buttons (Present, Import, Export)

**CSS Classes:**
- `.sidebar`: 250px fixed width, full height
- `.sidebar-header`: Title and add button
- `.sidebar-footer`: Action buttons at bottom

### Slide Item Component

**viewSlideItem : Model -> Int -> Slide -> Html Msg**

Individual slide in the navigation list.

**Features:**
- Click to select
- Drag and drop to reorder
- Action buttons (up, down, delete, duplicate)
- Visual states: active, dragging
- Image thumbnail (if slide has image)
- Preview text (first line)

**CSS Classes:**
- `.slide-item`: Base style
- `.slide-item.active`: Selected slide (dark background)
- `.slide-item.dragging`: Being dragged (50% opacity)
- `.drop-placeholder`: Visual indicator for drop position

**Drag and Drop:**
- `draggable="true"` on slide item
- `DragStart`, `DragOver`, `DragEnd`, `Drop` messages
- Visual placeholder shows drop target
- Prevents dragging active slide onto itself

### Editor Panel Component

**viewEditor : Model -> Html Msg**

Right side panel with textarea and preview.

**Structure:**
- Editor section (textarea)
- Preview section (rendered markdown)
- Image upload/remove buttons
- Conditional display based on image presence

**Editor Features:**
- Multi-line textarea for markdown
- Auto-save on blur
- Focus/blur tracking (disables shortcuts while typing)
- Placeholder text

**Preview Features:**
- Live markdown rendering
- Shows as slide would appear
- Displays image if present
- Split layout preview when applicable

**CSS Classes:**
- `.editor-panel`: Right side container
- `.editor`: Textarea section
- `.preview`: Rendered markdown section

### Image Handling

**Upload Methods:**
1. Paste from clipboard (automatic via port)
2. File upload button
3. Import from PPTX

**Display:**
- Thumbnail in slide list (60x45px)
- Full size in preview
- Responsive sizing in presentation

**CSS:**
- `.slide-thumbnail`: Small preview in sidebar
- `.preview img`: Full size in editor preview

## Presentation Mode Components

### Layout Structure

```
┌─────────────────────────────────────────────────┐
│ present-mode                                    │
│                                                 │
│                                                 │
│         ┌───────────────────────┐               │
│         │  slide-container      │               │
│         │                       │               │
│         │  Content here         │               │
│         │  (left-aligned)       │               │
│         │                       │               │
│         └───────────────────────┘               │
│                                                 │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Present View Component

**viewPresentMode : Model -> Html Msg**

Full-screen slide display with centered container.

**CSS Classes:**
- `.present-mode`: Full viewport, beige background (#f5f5f0)
- `.slide-container`: Centered content container
- `.slide-content`: Left-aligned slide content

### Layout-Specific Rendering

**Four layout types** (auto-detected):

1. **Title Slide** (index 0):
   - Large centered title
   - Subtitle below
   - No image

2. **Content Slide**:
   - Markdown content only
   - Left-aligned text
   - Full width

3. **Split Slide**:
   - Left side: Markdown (50% width)
   - Right side: Image (50% width)
   - Side-by-side layout

4. **Image Slide**:
   - Full-screen image
   - Centered
   - No text

**CSS Layout:**
- `.present-title`: Title slide styling
- `.present-content`: Content slide styling  
- `.present-split`: Two-column layout
- `.present-image`: Full-screen image

## Shared Components

### Markdown Rendering

**Module:** `MarkdownView.elm`

```elm
renderMarkdown : String -> Html msg
```

Uses `dillonkearns/elm-markdown` library with custom renderer.

**Features:**
- Standard markdown support
- Headings, lists, emphasis
- Code blocks
- Links and images
- Custom HTML rendering

**Shared Usage:**
- Editor preview (Edit mode)
- Slide display (Present mode)
- Consistent rendering across modes

### Help Dialog Component

**viewHelpDialog : Html Msg**

Modal overlay with keyboard shortcuts.

**Structure:**
- Overlay (semi-transparent background)
- Dialog box (centered, scrollable)
- Header with title and close button
- Content sections (Navigation, Presentation, Help)
- Shortcut items (key + description)

**CSS Classes:**
- `.help-overlay`: Full-screen overlay
- `.help-dialog`: Dialog box container
- `.help-header`: Title and close button
- `.help-content`: Scrollable content area
- `.help-section`: Group of related shortcuts
- `.help-shortcut`: Individual shortcut row
- `.help-keys`: Keyboard key display
- `.help-description`: Shortcut description

**Interaction:**
- Click overlay to close
- Click inside dialog doesn't close (stopPropagation)
- ESC key to close
- ? key to toggle

## CSS Architecture

### Design Philosophy

**Principles:**
- Minimal, clean aesthetic
- Left-aligned content (no centering)
- High contrast for readability
- Consistent spacing and sizing
- No animations (except transitions)

**Color Palette:**
- Background: `#f5f5f0` (warm beige)
- Text: `#1a1a1a` (near black)
- Accent: `#2a7` (green for actions)
- Border: `#d0d0c8` (light gray)
- Active: `#1a1a1a` (dark background)

### Layout System

**Fixed Dimensions:**
- Sidebar: 250px width
- Button height: 28px (icons), 36px (actions)
- Thumbnail: 60px × 45px
- Spacing: 0.5rem, 1rem increments

**Responsive:**
- Editor panel: flex-grow
- Preview: scrollable if content overflows
- Help dialog: 90% width, max 600px

### Component Classes

**Buttons:**
- `.btn-*`: Base button styles
- `.btn-icon`: Icon-only small buttons
- `.btn-present`, `.btn-import-pptx`, `.btn-export`: Action buttons
- Icon + label layout with gap

**Interactive States:**
- `:hover`: Lighter background
- `.active`: Dark background (sidebar items)
- `.dragging`: Reduced opacity
- `:focus`: Outline visible

**Typography:**
- Base: sans-serif
- Code: 'Courier New', monospace
- Headings: Bold, scaled sizes

## Event Handling

### Keyboard Events

**Global Listener:**
- Browser.Events.onKeyDown
- Filtered by mode and focus state
- Prevented when textarea focused

**Shortcuts:**
- Navigation: j/k, arrows, g/G
- Actions: p (present), ? (help)
- Modal: ESC (close)

### Mouse Events

**Drag and Drop:**
- `dragstart`: Set draggedSlideIndex
- `dragover`: Set dropTargetIndex
- `drop`: Reorder slides
- `dragend`: Clear drag state

**Click Events:**
- Slide selection
- Button actions
- Dialog close (overlay click)

### Focus Events

**Textarea:**
- `focus`: Set isTextareaFocused = True
- `blur`: Set isTextareaFocused = False, save content

**Purpose:**
- Disable keyboard shortcuts while typing
- Auto-save on blur

## Rendering Patterns

### Conditional Rendering

```elm
-- Show/hide based on state
if model.showHelpDialog then
    viewHelpDialog
else
    text ""

-- List rendering
List.indexedMap viewSlideItem slides

-- Optional image
case slide.image of
    Just src -> img [ src src ] []
    Nothing -> text ""
```

### CSS Classes

```elm
-- Dynamic class names
class (if isActive then "slide-item active" else "slide-item")

-- Multiple classes
String.join " " ["slide-item", activeClass, draggingClass]
```

### Event Handlers

```elm
-- Simple events
onClick AddSlide

-- Custom events with data
onClick (GoToSlide index)

-- Prevent default
preventDefaultOn "drop" (Decode.succeed (Drop index, True))
```

## Accessibility Considerations

### Current State

**Keyboard Navigation:**
- ✅ All features accessible via keyboard
- ✅ VIM-style shortcuts
- ✅ Focus management (textarea)

**Screen Readers:**
- ⚠️ Missing ARIA labels on buttons
- ⚠️ No live region announcements
- ⚠️ No landmark regions

**Visual:**
- ✅ High contrast colors
- ✅ Clear focus indicators
- ✅ Sufficient text size

### Future Improvements

See [TODO-A11Y.md](../TODO-A11Y.md) for planned accessibility enhancements.

## Performance

### Optimization Strategies

**Virtual DOM:**
- Elm runtime handles efficient diffing
- Only changed elements re-render
- Pure functions enable optimization

**Large Slide Decks:**
- No virtualization (all slides in DOM)
- Potential issue with 100+ slides
- Could add virtual scrolling if needed

**Image Handling:**
- Data URIs stored in memory
- No lazy loading
- Browser caching helps

## Testing UI Components

### Manual Testing

Document in [MANUAL_TESTING.md](../MANUAL_TESTING.md):
- Visual regression testing
- Cross-browser testing
- Responsive layout testing
- Interaction testing

### Automated Testing

**View Tests:**
- Difficult to unit test views
- Focus on logic, not rendering
- Use elm-test for helper functions

**Integration:**
- Manual browser testing
- Screenshot comparison (future)

## See Also

- [Architecture Documentation](./architecture.md) - Overall structure and message flow
- [Data Model Documentation](./data-model.md) - Types and data structures
- [Build and Dev Documentation](./build-and-dev.md) - Development setup

## Maintenance Notes

- Update when adding new components
- Document new CSS classes
- Keep layout diagrams current
- Note accessibility improvements
- Update color palette if changed
