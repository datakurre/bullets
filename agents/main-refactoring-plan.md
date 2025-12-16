# Main.elm Refactoring Plan

**Date:** 2025-12-16
**Status:** Planning

## Current State

Main.elm is 770 lines with a monolithic update function (~593 lines). This makes the file:
- Hard to navigate and understand
- Difficult to test individual update logic
- Prone to merge conflicts
- Challenging to maintain

## Refactoring Strategy

### Phase 1: Extract Update Logic (Priority: High)

Create separate modules for different update concerns:

#### 1. Update.Navigation module
Extract navigation-related update logic:
- `NextSlide`
- `PrevSlide`  
- `GoToSlide`
- Navigation helpers

#### 2. Update.Slide module  
Extract slide manipulation logic:
- `AddSlide`
- `DeleteSlide`
- `DuplicateSlide`
- `MoveSlideUp`
- `MoveSlideDown`
- `DragStart`, `DragOver`, `DragEnd`, `Drop`

#### 3. Update.Content module
Extract content editing logic:
- `UpdateContent`
- `UpdateTitle`

#### 4. Update.Image module
Extract image handling logic:
- `ImagePasted`
- `ImageUploadRequested`
- `ImageFileSelected`
- `ImageFileLoaded`
- `RemoveImage`

#### 5. Update.FileIO module
Extract file operations:
- `ImportPPTXRequested`
- `PPTXImported`
- `ExportToPPTX`

#### 6. Update.Mode module
Extract mode switching:
- `EnterPresentMode`
- `ExitPresentMode`

#### 7. Update.Keyboard module
Extract keyboard handling:
- `KeyPressed`
- `TextareaFocused`
- `TextareaBlurred`
- `ToggleHelpDialog`

#### 8. Update.Storage module
Extract storage:
- `LocalStorageLoaded`

### Phase 2: Extract View Helpers (Priority: Medium)

Main.elm contains view helpers that could be extracted:

#### View.HelpDialog module
- `viewHelpDialog` and related functions
- `viewShortcut`

### Phase 3: Create Update Coordinator (Priority: High)

Create `Update.elm` module that:
- Imports all Update.* modules
- Provides a single `update` function
- Routes messages to appropriate handlers
- Maintains clean separation of concerns

```elm
module Update exposing (update)

import Update.Navigation
import Update.Slide
import Update.Content
-- ... other imports

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- Navigation
        NextSlide -> Update.Navigation.nextSlide model
        PrevSlide -> Update.Navigation.prevSlide model
        
        -- Slides
        AddSlide -> Update.Slide.addSlide model
        DeleteSlide index -> Update.Slide.deleteSlide index model
        
        -- ... delegate to appropriate modules
```

## Benefits

1. **Maintainability:** Each module has single responsibility
2. **Testability:** Can unit test update logic in isolation
3. **Readability:** Easier to find and understand specific functionality
4. **Collaboration:** Reduces merge conflicts on Main.elm
5. **Reusability:** Update logic can be composed and reused

## Risks

1. **Breaking changes:** Refactoring could introduce bugs
2. **Test coverage:** Need comprehensive tests before refactoring
3. **Circular dependencies:** Must design module boundaries carefully
4. **Over-engineering:** Could make simple codebase complex

## Mitigation

1. **TDD approach:** Write tests first for current behavior
2. **Incremental refactoring:** Move one message type at a time
3. **Git discipline:** Small, atomic commits with clear messages
4. **Continuous testing:** Run tests after each extraction
5. **Keep it simple:** Only extract what provides clear benefit

## Alternative: Keep as-is

**Pros:**
- No refactoring risk
- Code works as-is
- Simple mental model (everything in one place)

**Cons:**
- Will get harder to maintain as features grow
- Already at 770 lines
- Large update function is hard to reason about

## Decision Criteria

Refactor if:
- Adding new features becomes difficult
- Update function exceeds 1000 lines
- Team feedback indicates maintenance issues
- Merge conflicts become frequent

Don't refactor if:
- Project is stable with few changes
- Team prefers simplicity over structure
- Risk outweighs benefits

## Recommendation

**Don't refactor yet** - Current size (770 lines) is manageable for a small project. The code is:
- Well-organized with clear sections
- Easy to navigate with section comments
- Working correctly with good test coverage
- Follows Elm architecture guidelines

**Future threshold:** Consider refactoring when Main.elm exceeds 1000 lines or when adding features becomes noticeably harder.

## Alternative Improvements

Instead of full refactoring, consider:

1. **Add more comments:** Document complex update cases
2. **Extract helper functions:** Move complex calculations to named functions
3. **Better type aliases:** Create semantic types for complex data structures
4. **Documentation:** Add module-level documentation explaining architecture

## Notes

Elm's single-file approach is often preferable for small to medium apps. The framework encourages keeping related logic together. Premature modularization can actually make code harder to follow.

The current 770 lines includes:
- Main (~50 lines)
- Init (~10 lines)
- Update (~593 lines)
- Subscriptions (~20 lines)
- View (~100 lines with help dialog)

If the update function could be reduced below 400 lines through helper functions, that would be sufficient.

## References

- Elm Architecture: https://guide.elm-lang.org/architecture/
- Scaling Elm Apps: https://www.elm-tutorial.org/en/05-resources/02-scaling.html
- "Making Impossible States Impossible" talk by Richard Feldman
