# Manual Testing Checklist

This document describes manual tests that need to be performed to ensure all features work correctly.

## Keyboard Shortcuts Testing

### Presentation Mode Keyboard Shortcuts
Start presentation mode first by clicking "▶ Present" button, then test:

- [ ] **ArrowRight** - Navigate to next slide
- [ ] **Space** - Navigate to next slide  
- [ ] **Enter** - Navigate to next slide
- [ ] **ArrowLeft** - Navigate to previous slide
- [ ] **Escape** - Exit presentation mode
- [ ] **j** - Navigate to next slide (VIM binding)
- [ ] **k** - Navigate to previous slide (VIM binding)
- [ ] **h** - Navigate to previous slide (VIM binding)
- [ ] **l** - Navigate to next slide (VIM binding)
- [ ] **g** - Go to first slide (VIM binding)
- [ ] **G** (Shift+g) - Go to last slide (VIM binding)

### Edit Mode Keyboard Shortcuts
Test in edit mode (when not focused on textarea):

- [ ] **j** - Navigate to next slide
- [ ] **k** - Navigate to previous slide
- [ ] **p** - Enter presentation mode
- [ ] **g** - Go to first slide
- [ ] **G** (Shift+g) - Go to last slide

Note: These shortcuts should NOT work when the textarea is focused (cursor is in the content editor).

## Image Paste Functionality

- [ ] Click on a slide with "Markdown + Image" layout
- [ ] Copy an image to clipboard (from browser, screenshot tool, etc.)
- [ ] Press Ctrl+V (Cmd+V on Mac) while focused on the application
- [ ] Verify the image appears in the slide
- [ ] Verify the image is saved (refresh page and check if it persists)

## File Download/Upload Functionality

### JSON Export (Download)
- [ ] Create a presentation with multiple slides
- [ ] Add content to slides
- [ ] Add images to some slides
- [ ] Click "💾 Save" button
- [ ] Verify a JSON file downloads
- [ ] Open the JSON file and verify it contains the presentation data

### JSON Import (Load)
- [ ] Click "📁 Load" button
- [ ] Select a previously exported JSON file
- [ ] Verify all slides load correctly
- [ ] Verify slide content is preserved
- [ ] Verify images are preserved
- [ ] Verify layout settings are preserved

### Local Storage
- [ ] Create a presentation with content
- [ ] Refresh the browser
- [ ] Verify the presentation is automatically loaded from local storage

### Image Upload
- [ ] Select a slide with "Markdown + Image" layout
- [ ] Click "📁 Upload Image" button
- [ ] Select an image file from your computer
- [ ] Verify the image appears in the slide
- [ ] Verify the image persists after refresh

## Drag and Drop Slide Arrangement

- [ ] Create multiple slides (at least 5)
- [ ] Click and hold on a slide in the sidebar
- [ ] Drag the slide to a different position
- [ ] Release the mouse button
- [ ] Verify the slide moves to the new position
- [ ] Verify the slide order is preserved after refresh
- [ ] Verify the currently selected slide is updated correctly if you drag it
- [ ] Test dragging first slide to last position
- [ ] Test dragging last slide to first position
- [ ] Test dragging middle slide to different positions

## Cross-Browser Testing

Test all core functionality in the following browsers:

### Chrome
- [ ] All keyboard shortcuts work
- [ ] Image paste works
- [ ] File download/upload works
- [ ] Drag and drop works
- [ ] Presentation mode displays correctly
- [ ] Markdown rendering is correct
- [ ] Images display correctly

### Firefox
- [ ] All keyboard shortcuts work
- [ ] Image paste works
- [ ] File download/upload works
- [ ] Drag and drop works
- [ ] Presentation mode displays correctly
- [ ] Markdown rendering is correct
- [ ] Images display correctly

### Safari
- [ ] All keyboard shortcuts work
- [ ] Image paste works
- [ ] File download/upload works
- [ ] Drag and drop works
- [ ] Presentation mode displays correctly
- [ ] Markdown rendering is correct
- [ ] Images display correctly

## Visual/Layout Testing

### Markdown Styles
- [ ] All text is left-aligned (no center alignment)
- [ ] Headings have proper spacing
- [ ] Bullet lists use en-dash (–) character
- [ ] Bullets are properly aligned with heading text
- [ ] Preview matches presentation mode

### Slide Layouts
- [ ] "Markdown" layout displays content correctly
- [ ] "Markdown + Image" layout displays split view correctly
- [ ] Image-only slides (no markdown content) display fullscreen image
- [ ] Cover slide style (heading + text) displays correctly
- [ ] Title-only slides display correctly

## Regression Testing

After any changes, verify:
- [ ] Existing presentations still load correctly
- [ ] No JavaScript errors in console
- [ ] All buttons and controls are responsive
- [ ] Navigation between slides works smoothly
- [ ] Edit mode and present mode switch correctly

## Test Server

To test locally:
1. Build the project: `make build`
2. Start a local server: `python3 -m http.server 8080`
3. Open browser to: `http://localhost:8080`

