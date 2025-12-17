# VIM-Capable Editor Research for Bullets

**Type:** Research Document  
**Date:** 2024-12-16
**Status:** Research Complete

> **Note:** This document contains research for a potential future feature. The decision was to keep the current textarea implementation (see ADR 001). This document is kept for reference if advanced VIM text editing is needed in the future.

## Objective

Evaluate VIM-capable markdown editors that can replace the current textarea in the bullets presentation tool. The editor must be compatible with Elm and support VIM keybindings for text editing.

## Requirements

1. **Elm Compatibility:** Must work with Elm via ports or native bindings
2. **VIM Mode:** Support for VIM keybindings within the editor
3. **Markdown Support:** Syntax highlighting for markdown (desirable)
4. **Lightweight:** Should not significantly increase bundle size
5. **Accessibility:** Must maintain keyboard accessibility standards
6. **License:** Compatible with project license

## Options Evaluated

### Option 1: CodeMirror 6 (Recommended)

**Description:** Modern, extensible code editor with excellent architecture

**Pros:**
- Native VIM mode support via `@codemirror/legacy-modes/mode/vim`
- Excellent markdown support
- Modular design - include only needed features
- Strong accessibility support
- Active development and maintenance
- Can be integrated via Elm ports
- ~50-80KB gzipped for basic setup with VIM mode

**Cons:**
- Requires JavaScript integration via ports
- Learning curve for port setup
- More complex than textarea

**Integration:**
```javascript
// Basic CodeMirror 6 with VIM mode setup
import { EditorView, basicSetup } from "codemirror"
import { markdown } from "@codemirror/lang-markdown"
import { vim } from "@replit/codemirror-vim"

const editor = new EditorView({
  extensions: [
    basicSetup,
    markdown(),
    vim()
  ],
  parent: document.getElementById('editor')
})

// Port communication with Elm
app.ports.updateEditorContent.subscribe(content => {
  editor.dispatch({
    changes: { from: 0, to: editor.state.doc.length, insert: content }
  })
})

editor.state.field.onDocChange = () => {
  app.ports.editorContentChanged.send(editor.state.doc.toString())
}
```

**Resources:**
- https://codemirror.net/
- https://github.com/replit/codemirror-vim
- https://codemirror.net/examples/bundle/

### Option 2: Monaco Editor (VS Code Editor)

**Description:** The editor powering Visual Studio Code

**Pros:**
- Feature-rich, battle-tested
- VIM extension available: monaco-vim
- Excellent markdown support
- IntelliSense and autocomplete
- Strong accessibility features

**Cons:**
- Very large bundle size (~2-3MB minified)
- Overkill for simple markdown editing
- Complex integration
- May slow down page load significantly
- VIM mode is third-party extension

**Verdict:** Too heavy for bullets' use case

### Option 3: Ace Editor

**Description:** Mature embeddable code editor

**Pros:**
- Built-in VIM mode
- Markdown mode available
- Mature and stable
- ~400KB minified
- Well-documented

**Cons:**
- Less modern architecture than CodeMirror 6
- Larger than CodeMirror
- VIM mode less comprehensive than CodeMirror's
- Development less active

**Verdict:** Good option, but CodeMirror 6 is more modern

### Option 4: Custom VIM Implementation

**Description:** Build VIM keybindings on top of existing textarea

**Pros:**
- No external dependencies
- Full control over implementation
- Smallest bundle size
- Already partially implemented (navigation keybindings exist)

**Cons:**
- Significant development effort
- Need to implement all VIM modes (normal, insert, visual)
- Need to implement VIM motions (w, b, e, $, ^, etc.)
- Need to implement VIM operators (d, c, y, etc.)
- Difficult to maintain parity with real VIM
- May introduce bugs

**Verdict:** Not recommended - reinventing the wheel

### Option 5: Keep Current Textarea

**Description:** Continue using native HTML textarea

**Pros:**
- Zero additional dependencies
- Best performance
- Fully accessible
- Simple implementation
- No bundle size increase
- Navigation VIM keybindings already work

**Cons:**
- No VIM mode for text editing (only navigation)
- No syntax highlighting
- Basic editing experience
- No VIM motions within content

**Verdict:** Acceptable for MVP, but limits power user experience

## Recommendation

### Short Term: Keep Current Textarea

For now, maintain the current textarea implementation because:
1. Navigation VIM keybindings already provide significant value
2. The application focuses on presentations, not extensive text editing
3. Markdown content is typically brief (slide-sized)
4. Zero bundle size impact
5. No additional complexity

### Long Term: Integrate CodeMirror 6 with VIM Mode

When ready to enhance the editing experience:
1. Add CodeMirror 6 as an optional enhancement
2. Implement via Elm ports
3. Include VIM extension for power users
4. Add markdown syntax highlighting
5. Maintain fallback to textarea for progressive enhancement

## Implementation Strategy for CodeMirror 6

### Phase 1: Port Infrastructure
1. Create ports for editor content sync
2. Set up bidirectional communication
3. Test basic text editing

### Phase 2: CodeMirror Integration
1. Add CodeMirror 6 to dependencies
2. Initialize editor with basic setup
3. Connect to Elm ports
4. Test content synchronization

### Phase 3: VIM Mode
1. Add @replit/codemirror-vim extension
2. Configure VIM mode settings
3. Test VIM keybindings
4. Document VIM commands

### Phase 4: Enhancements
1. Add markdown syntax highlighting
2. Configure editor theme to match app style
3. Add line numbers (optional)
4. Test accessibility

## Decision

**Current:** Keep textarea - it's sufficient for the application's needs
**Future:** CodeMirror 6 with VIM mode when enhanced editing is required

## References

- CodeMirror 6: https://codemirror.net/
- @replit/codemirror-vim: https://github.com/replit/codemirror-vim
- Monaco Editor: https://microsoft.github.io/monaco-editor/
- Ace Editor: https://ace.c9.io/
- Elm Ports: https://guide.elm-lang.org/interop/ports.html

## Notes

The current implementation with textarea is pragmatic and aligns with the project's minimalist philosophy. VIM navigation keybindings (j/k/g/G/p) already provide significant productivity benefits for slide navigation. Adding a full VIM editor would be a significant complexity increase for marginal benefit in the context of short-form slide content.

If user feedback indicates a need for advanced VIM text editing, CodeMirror 6 is the clear choice for future enhancement.
