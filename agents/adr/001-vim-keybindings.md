# ADR 001: VIM-Style Keybindings for Navigation and Editing

**Status:** Accepted
**Date:** 2024-12-16  
**Last Reviewed:** 2024-12-17
**Deciders:** Project maintainers  

## Context

The bullets presentation tool needs efficient keyboard navigation for power users. Traditional presentation tools often rely heavily on mouse interaction, which can slow down the editing workflow. VIM-style keybindings are widely recognized among developers and power users as an efficient means of navigation without reaching for arrow keys or a mouse.

## Decision

We will implement VIM-style keybindings for both Edit Mode and Presentation Mode, while ensuring they don't conflict with standard text editing functionality.

### Edit Mode Keybindings

**Navigation (when textarea is NOT focused):**
- `j` - Move to next slide
- `k` - Move to previous slide
- `g` - Go to first slide
- `G` - Go to last slide (capital G)
- `p` - Enter presentation mode
- `ArrowDown` - Move to next slide (alternative)
- `ArrowUp` - Move to previous slide (alternative)

**Critical Rule:** All VIM keybindings are disabled when the textarea is focused to prevent conflicts with normal text editing. Users can type 'j', 'k', 'g', 'G', 'p' freely in their markdown content.

### Presentation Mode Keybindings

**Navigation:**
- `j` - Next slide
- `k` - Previous slide
- `h` - Previous slide (alternative, matching VIM's left motion)
- `l` - Next slide (alternative, matching VIM's right motion)
- `g` - Go to first slide
- `G` - Go to last slide
- `ArrowRight` - Next slide (alternative)
- `ArrowLeft` - Previous slide (alternative)
- `Space` - Next slide (alternative)
- `Enter` - Next slide (alternative)
- `Escape` - Exit presentation mode

## Implementation Details

### Focus Detection

The implementation tracks textarea focus state using `isTextareaFocused` in the model. This is updated via:
- `TextareaFocused` message - Sets `isTextareaFocused = True`
- `TextareaBlurred` message - Sets `isTextareaFocused = False`

The textarea in View.Edit module has:
```elm
, onFocus TextareaFocused
, onBlur TextareaBlurred
```

### Key Handling

All keyboard input is captured via a subscription to `Browser.Events.onKeyDown`:
```elm
Browser.Events.onKeyDown keyDecoder
```

The `update` function checks the current mode (Edit vs Present) and whether textarea is focused before processing VIM keybindings:
```elm
case model.mode of
    Edit ->
        if model.isTextareaFocused then
            ( model, Cmd.none )
        else
            -- Process VIM keybindings
```

## Rationale

### Why VIM-style?

1. **Familiarity:** Many developers and power users are already familiar with VIM navigation
2. **Efficiency:** Home row navigation is faster than reaching for arrow keys
3. **Consistency:** The h/j/k/l pattern is well-established and intuitive once learned
4. **No conflicts:** Can be disabled during text editing without loss of functionality

### Why hjkl in Presentation Mode?

- `h` and `l` map naturally to left/right (horizontal) navigation
- `j` and `k` map to down/up, which translates to next/previous in a linear presentation
- Maintains muscle memory for VIM users

### Why g/G for First/Last?

- Matches VIM's "go to" semantics (gg for first line, G for last line)
- In Elm, we use single `g` for first since we capture single keystrokes
- `G` (capital G) naturally maps to "end" in VIM

### Why 'p' for Present?

- Mnemonic: 'p' for "present" or "presentation"
- Not a standard VIM binding, so no conflict with user expectations
- Easy to remember and execute

## Alternatives Considered

### Alternative 1: Arrow Keys Only
**Rejected:** Requires moving hands away from home row, slower for power users

### Alternative 2: Custom Keybindings (e.g., Ctrl+shortcuts)
**Rejected:** More key combinations to remember, conflicts with browser shortcuts

### Alternative 3: Emacs-style keybindings
**Rejected:** Less common among developer community, more complex modifier combinations

### Alternative 4: Always active VIM keybindings (even in textarea)
**Rejected:** Would make it impossible to type these letters in slide content

## Consequences

### Positive

- Fast keyboard-only workflow for editing and presenting
- Familiar to VIM users and easy to learn for others
- No mouse required for core functionality
- Consistent with developer tool expectations
- Enhances accessibility (keyboard-only users)

### Negative

- Learning curve for users unfamiliar with VIM
- Need to document keybindings clearly
- Focus management adds complexity to implementation
- Capital 'G' requires Shift key, slightly slower than 'g'

### Neutral

- Coexists with traditional arrow keys and mouse navigation
- Requires help dialog to make keybindings discoverable

## Future Considerations

### VIM-Capable Editor for Markdown Editing

**Current Implementation:** Standard HTML textarea without VIM text editing capabilities

**Status:** Researched and documented in `agents/vim-editor-research.md`

**Decision:** Keep current textarea for now because:
1. Slide content is typically brief - full VIM editor is overkill
2. Navigation VIM keybindings (j/k/g/G/p) already provide significant value
3. Zero additional bundle size and complexity
4. Aligns with project's minimalist philosophy
5. Sufficient for current use cases

**Future Option:** CodeMirror 6 with VIM mode if enhanced editing is needed
- Modern, lightweight, excellent VIM support via `@replit/codemirror-vim`
- Would require Elm ports integration
- See `agents/vim-editor-research.md` for full evaluation and implementation strategy

### Potential Additions

1. **Slide manipulation:**
   - `dd` - Delete current slide (double-d like VIM's delete line)
   - `yy` - Duplicate/yank current slide
   - `i` - Focus textarea (insert mode)

2. **Visual feedback:**
   - Show current mode indicator (edit vs normal)
   - Display keybinding hints on first use

3. **Help dialog:**
   - `h` or `?` to show keybinding help (needs to not conflict with h for left)
   - Consider F1 or Ctrl+? instead

4. **Search:**
   - `/` to search within slides
   - `n` for next match, `N` for previous

## References

- VIM Navigation: http://vim.wikia.com/wiki/Navigation
- WCAG Keyboard Accessibility: https://www.w3.org/WAI/WCAG21/Understanding/keyboard

## Notes

This ADR documents the current implementation as of commit 8e3ab5e. The focus detection mechanism ensures VIM keybindings don't interfere with content editing, which is a critical UX requirement.

Future enhancements should maintain this principle: **VIM keybindings are a productivity enhancement, not a barrier to basic functionality.**
