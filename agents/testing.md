# Testing Documentation

**Purpose**: Comprehensive guide to testing strategy, test organization, and quality assurance for the bullets presentation tool.

**Last Updated**: 2024-12-17

## Overview

The bullets project follows a **Test-Driven Development (TDD)** approach for business logic, with a comprehensive unit test suite and manual testing procedures for UI interactions. The project maintains high test coverage for critical paths while being pragmatic about what can be effectively unit tested.

## Testing Strategy

### Test Coverage Philosophy

**Unit Test**: Pure functions that can be tested in isolation
- Encoders/decoders (JSON serialization)
- Data transformations
- Navigation logic
- Slide manipulation
- Business logic

**Manual Test**: UI interactions and visual verification
- Drag and drop behavior
- Keyboard navigation feel
- Visual layout and styling
- Cross-browser compatibility
- Performance characteristics

### Current Status

- **146 unit tests** covering core functionality
- **All tests passing** in CI/CD pipeline
- Focus areas:
  - JSON serialization/deserialization (round-trip correctness)
  - Navigation logic (boundary conditions, state transitions)
  - Slide manipulation (add, delete, duplicate, reorder)

## Test-Driven Development (TDD)

### TDD Enforcement

**ENFORCE TDD** for all new features and bug fixes that involve business logic.

### TDD with BDD Patterns

When writing tests first, use **BDD (Behavior-Driven Development)** patterns to make tests more readable:

1. **Write behavior description**: Start with nested `describe` blocks describing the context and action
2. **Write failing test**: Add `test` with "should" describing expected outcome
3. **Run tests to confirm failure**: Verify the test fails (`make test`)
4. **Implement the minimal code**: Write just enough code to make the test pass
5. **Run tests to confirm success**: Verify all tests pass (`make test`)
6. **Refactor if needed**: Improve the code while keeping tests green
7. **Format code**: Run `make format` before committing

Example TDD workflow:
```elm
-- Step 1: Write the behavior description and failing test
describe "given an empty presentation"
    [ describe "when adding a new slide"
        [ test "should add the slide to the presentation" <|
            \_ ->
                -- Test implementation that will fail initially
                model
                    |> addSlide
                    |> .slides
                    |> List.length
                    |> Expect.equal 1
        ]
    ]

-- Step 2: Run tests (should fail)
-- Step 3: Implement addSlide function
-- Step 4: Run tests (should pass)
-- Step 5: Refactor if needed
```

### When to Apply TDD

**ALWAYS** for:
- Pure functions (encoders, decoders, transformations, utilities)
- Business logic (slide manipulation, navigation logic, data validation)
- Bug fixes (write a test that reproduces the bug first)

**Optional** for:
- UI changes that are difficult to unit test
- Visual styling adjustments
- Exploratory development (but add tests after)

### TDD Benefits

- **Confidence**: Tests verify behavior is correct
- **Documentation**: Tests serve as executable specifications
- **Regression Prevention**: Tests catch breaking changes
- **Design**: TDD encourages better API design
- **Refactoring Safety**: Tests enable safe code improvements

## Test Organization

### Directory Structure

```
tests/
├── AccessibilityTest.elm     # Accessibility tests (ARIA, keyboard nav, etc.)
├── JsonTest.elm              # JSON encoding/decoding tests
├── NavigationTest.elm        # Navigation logic tests
├── SlideManipulationTest.elm # Slide manipulation tests
└── Update/                   # Update function tests organized by module
    ├── ContentTest.elm       # Content update tests
    ├── FileIOTest.elm        # File I/O tests (PPTX import/export)
    ├── ImageTest.elm         # Image handling tests
    ├── ModeTest.elm          # Mode switching tests
    ├── NavigationTest.elm    # Navigation update tests
    ├── SlideTest.elm         # Slide update tests
    ├── StorageTest.elm       # Local storage tests
    └── UITest.elm            # UI state tests
```

### File Naming Convention

- Test files match source module names with `Test` suffix
- Example: `src/Json.elm` → `tests/JsonTest.elm`
- Place tests in `tests/` directory at same hierarchy level

### Test Structure

Tests use `elm-test` with `describe`/`test` structure, following **BDD (Behavior-Driven Development)** patterns for improved readability and intent.

#### BDD Pattern

All tests follow a **given-when-then** structure using nested `describe` blocks:

```elm
module Update.NavigationTest exposing (suite)

import Expect
import Test exposing (Test, describe, test)

suite : Test
suite =
    describe "Update.Navigation"
        [ describe "nextSlide"
            [ describe "given a presentation with multiple slides"
                [ describe "when navigating to next slide from the first slide"
                    [ test "should move to the next slide" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides 3
                                        |> (\m -> { m | currentSlideIndex = 0 })

                                ( newModel, _ ) =
                                    Update.Navigation.nextSlide model
                            in
                            Expect.equal 1 newModel.currentSlideIndex
                    ]
                , describe "when at the last slide"
                    [ test "should stay at the last slide" <|
                        \_ ->
                            let
                                model =
                                    modelWithSlides 3
                                        |> (\m -> { m | currentSlideIndex = 2 })

                                ( newModel, _ ) =
                                    Update.Navigation.nextSlide model
                            in
                            Expect.equal 2 newModel.currentSlideIndex
                    ]
                ]
            ]
        ]
```

#### BDD Structure

- **Given** (context): Nested `describe` blocks that start with "given"
  - Sets up the context or initial state
  - Example: `describe "given a presentation with multiple slides"`
  
- **When** (action): Nested `describe` blocks that start with "when"
  - Describes the action being performed
  - Example: `describe "when navigating to next slide"`
  
- **Then** (outcome): `test` names that start with "should"
  - Describes the expected outcome
  - Example: `test "should move to the next slide"`

#### Test Naming Convention

Test names complete the sentence started by the describe blocks:

```
Given a presentation with multiple slides
  When navigating to next slide
    → should move to the next slide
    → should announce the new slide number
```

This creates readable test output that documents the behavior.

### Test Naming

Tests follow **BDD (Behavior-Driven Development)** naming patterns for improved readability:

- **Describe blocks (Given)**: Set context with "given" - describes the initial state
  - Example: `describe "given a presentation with multiple slides"`
  
- **Describe blocks (When)**: Set action with "when" - describes what happens
  - Example: `describe "when navigating to next slide"`
  
- **Test names (Should)**: Use "should" to describe expected outcome
  - Example: `test "should move to the next slide"`

#### Good BDD Examples

✅ Nested structure with clear intent:
```elm
describe "given a presentation with one slide"
    [ describe "when attempting to delete the last slide"
        [ test "should prevent deletion of the last slide" <|
            -- test implementation
        ]
    ]
```

✅ Clear behavior description:
```elm
describe "given the help dialog is visible"
    [ describe "when toggling the help dialog"
        [ test "should hide the help dialog" <|
            -- test implementation
        ]
    ]
```

#### Bad Examples

❌ No context or structure:
```elm
test "test 1" <|
    -- unclear what is being tested
```

❌ Implementation details instead of behavior:
```elm
test "sets index to 1" <|
    -- describes implementation, not behavior
```

❌ Missing "should" in test name:
```elm
test "moves to next slide" <|
    -- use "should move to next slide" instead
```

#### BDD Benefits

- **Readable**: Tests read like specifications
- **Documentation**: Test structure documents behavior
- **Intent**: Clear separation of context, action, and outcome
- **Maintainable**: Easy to locate and update related tests
- **Discoverable**: Grouped tests make it easy to understand functionality

## Test Suites

### AccessibilityTest.elm

Tests accessibility features including ARIA labels, keyboard navigation, and screen reader support.

**Focus areas**:
- ARIA role and label presence
- Keyboard navigation support
- Focus management
- Screen reader announcements
- Help dialog accessibility

### JsonTest.elm

Tests JSON encoding and decoding for data persistence.

**Focus areas**:
- Slide encoding/decoding
- Presentation encoding/decoding
- Round-trip correctness (encode then decode = identity)
- Handling of optional fields (Maybe values)
- Error cases (malformed JSON)

**Example tests**:
- Encode slide with content
- Encode slide with image
- Decode valid JSON
- Decode JSON with missing fields
- Round-trip preserves all data

### NavigationTest.elm

Tests navigation logic for both edit and presentation modes.

**Focus areas**:
- Next/previous slide navigation
- Boundary conditions (first/last slide)
- Jump to slide (g/G commands)
- Mode-specific behavior differences
- Index bounds checking

**Example tests**:
- Navigate to next slide
- Navigate to previous slide
- Stay at bounds (no wrap in edit mode)
- Wrap around in presentation mode
- Jump to first slide
- Jump to last slide

### SlideManipulationTest.elm

Tests slide management operations.

**Focus areas**:
- Add slide
- Delete slide
- Duplicate slide
- Move slide up/down
- Reorder via drag and drop
- Index adjustment after operations
- Edge cases (empty list, single slide)

**Example tests**:
- Add slide to end of list
- Delete slide updates indices
- Duplicate preserves content
- Move up/down changes order
- Cannot move beyond bounds
- Deleting current slide adjusts currentIndex

### Update Module Tests

Tests for the Update module and its submodules, organized by functionality.

#### Update/ContentTest.elm
Tests content update logic.

#### Update/FileIOTest.elm
Tests PPTX import/export functionality.

#### Update/ImageTest.elm
Tests image handling (clipboard paste, file upload).

#### Update/ModeTest.elm
Tests mode switching between edit and presentation modes.

#### Update/NavigationTest.elm
Tests navigation update logic.

#### Update/SlideTest.elm
Tests slide update operations.

#### Update/StorageTest.elm
Tests local storage save/load functionality.

#### Update/UITest.elm
Tests UI state management (drag/drop, help dialog).

## Running Tests

### Command Line

**Run all tests**:
```bash
make test
```

**Run tests with verbose output**:
```bash
elm-test
```

**Run specific test file**:
```bash
elm-test tests/JsonTest.elm
```

**Watch mode** (auto-run on changes):
```bash
elm-test --watch
```

### Test Output

Successful run:
```
TEST RUN PASSED

Duration: 150 ms
Passed:   146
Failed:   0
```

Failed test:
```
TEST RUN FAILED

Duration: 145 ms
Passed:   145
Failed:   1

↓ Navigation
↓ nextSlideIndex
✗ moves to next slide when not at end

    Expected: 1
    Actual: 0
```

## Coverage Reporting

### Generate HTML Report

```bash
make coverage
```

This creates:
- `coverage/index.html` - Styled HTML report
- `coverage/test-output.txt` - Raw test output

### View Report

```bash
xdg-open coverage/index.html
# or
firefox coverage/index.html
```

### Report Contents

The HTML report includes:
- Total tests passed/failed
- Test execution time
- Full test output with pass/fail indicators
- Timestamp of report generation

### Coverage Metrics

Currently tracking:
- **Total tests**: 146
- **Pass rate**: 100%
- **Test execution time**: ~150ms

Note: Elm doesn't have built-in code coverage tools like other languages. The "coverage" report shows test results, not line coverage.

## Manual Testing

### When to Manual Test

- UI layout changes
- Visual styling updates
- Keyboard navigation feel
- Drag and drop interactions
- Cross-browser compatibility
- Performance characteristics
- Accessibility features

### Manual Testing Checklist

**Edit Mode**:
- [ ] Add slide works
- [ ] Delete slide works and adjusts selection
- [ ] Duplicate slide copies content and image
- [ ] Reorder buttons move slides correctly
- [ ] Drag and drop reorders slides
- [ ] Visual placeholder shows during drag
- [ ] Image paste from clipboard works
- [ ] Image upload from file works
- [ ] Image preview shows in slide list
- [ ] Image thumbnail scales correctly
- [ ] Markdown preview updates in real-time
- [ ] Keyboard shortcuts work (j/k/g/G/p/arrows)
- [ ] Keyboard shortcuts disabled while typing
- [ ] Local storage saves automatically
- [ ] Import PPTX loads slides correctly
- [ ] Export PPTX creates valid file

**Presentation Mode**:
- [ ] Slides display correctly
- [ ] Markdown renders properly
- [ ] Images display at correct size
- [ ] Layout detection works (text/image/split)
- [ ] Content is left-aligned
- [ ] Slide is centered on screen
- [ ] Navigation keys work (arrows/space/enter/j/k/h/l)
- [ ] VIM shortcuts work (g/G)
- [ ] ESC exits to edit mode
- [ ] Focus returns correctly after exit

**Cross-Browser**:
- [ ] Chrome/Chromium
- [ ] Firefox
- [ ] Safari (if available)
- [ ] Edge

**Accessibility**:
- [ ] Keyboard-only navigation works
- [ ] Focus indicators visible
- [ ] Screen reader compatibility (basic)
- [ ] Color contrast adequate

### Documentation

Manual testing procedures can be documented in:
- Issue descriptions (for specific features)
- Pull request descriptions
- Release checklists
- Separate manual testing guides (if needed)

Note: Currently no formal `MANUAL_TESTING.md` exists, but one can be created if manual testing becomes more complex.

## Continuous Integration

### GitHub Actions Integration

Tests run automatically on every push to main:

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Setup Elm
        uses: jorelali/setup-elm@v5
        with:
          elm-version: 0.19.1
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
      
      - name: Install elm-test
        run: npm install -g elm-test
      
      - name: Run tests
        run: elm-test
```

### CI Behavior

- Tests run before build job
- Build only proceeds if tests pass
- Deployment blocked if tests fail
- Test failures show in PR checks
- Easy to see which test failed

## Writing Good Tests

### Test Characteristics

**FIRST Principles**:
- **Fast**: Tests should run quickly
- **Independent**: Tests don't depend on each other
- **Repeatable**: Same result every time
- **Self-validating**: Clear pass/fail
- **Timely**: Written close to the code

### Test Quality Guidelines

1. **One assertion per test**: Focus on single behavior
2. **Clear test names**: Explain what is being tested
3. **Arrange-Act-Assert**: Structure tests clearly
4. **Test edge cases**: Boundaries, empty, null, max
5. **Avoid magic numbers**: Use named constants
6. **Keep tests simple**: Tests should be easy to understand

### Example: Good Test

```elm
test "deleting current slide adjusts index to previous slide" <|
    \_ ->
        let
            initialSlides = [ slide1, slide2, slide3 ]
            currentIndex = 1  -- On slide2
            
            result = deleteSlide currentIndex initialSlides
        in
        result.newIndex |> Expect.equal 0  -- Should move to slide1
```

### Example: Bad Test

```elm
test "delete works" <|
    \_ ->
        let
            result = deleteSlide 1 [ s1, s2, s3 ]
        in
        result.slides |> List.length |> Expect.equal 2
        -- What about index? What about edge cases?
```

## Test Data

### Creating Test Data

Use helper functions for common test data:

```elm
-- Good: Reusable test data
emptySlide : Slide
emptySlide =
    { content = "", image = Nothing }

slideWithContent : String -> Slide
slideWithContent content =
    { content = content, image = Nothing }

slideWithImage : String -> Slide
slideWithImage imageUri =
    { content = "", image = Just imageUri }
```

### Test Data Best Practices

- **Minimal**: Use smallest data that demonstrates behavior
- **Realistic**: Use realistic values where appropriate
- **Readable**: Make test data easy to understand
- **Reusable**: Share common test data via helpers
- **Focused**: Only include relevant fields

## Debugging Failed Tests

### Reading Test Output

1. **Locate the failed test**: Look for ✗ marker
2. **Read the description**: Understand what was expected
3. **Check Expected vs Actual**: See the difference
4. **Identify the cause**: Which code caused the failure
5. **Fix the code**: Update implementation
6. **Verify fix**: Run tests again

### Debugging Strategies

1. **Add Debug.log**: Temporary logging in test or code
2. **Simplify test**: Remove complexity to isolate issue
3. **Check assumptions**: Verify test expectations are correct
4. **Run in isolation**: Run single test file
5. **Review recent changes**: What changed to cause failure?

### Common Issues

**Type errors**:
- Usually caught by compiler
- Fix types before tests can run

**Logic errors**:
- Test fails with wrong value
- Review algorithm/implementation

**Edge cases**:
- Test passes for normal cases, fails for edges
- Add more edge case handling

**Test itself is wrong**:
- Sometimes the test expectations are incorrect
- Review requirements and update test

## Code Quality

### elm-review Integration

Static analysis tool checks:
- Unused imports
- Unused functions
- Naming conventions
- Code complexity
- Best practices

**Run review**:
```bash
elm-review
```

**Auto-fix issues**:
```bash
elm-review --fix
```

Configuration in `review/src/ReviewConfig.elm`

### Code Formatting

**elm-format** ensures consistent style:

```bash
make format
```

Should be run before every commit.

## Testing Elm Ports

### Challenge

Ports cannot be directly unit tested in Elm since they interact with JavaScript.

### Strategy

1. **Test pure logic**: Separate business logic from port calls
2. **Mock in tests**: Create test versions of port-dependent functions
3. **Manual test ports**: Verify port behavior manually in browser
4. **Integration tests**: Test full JavaScript integration manually

### Example

Instead of testing port directly:
```elm
-- Hard to test
saveToLocalStorage : Model -> Cmd Msg
saveToLocalStorage model =
    ports.saveToLocalStorage (encodeModel model)
```

Test the encoder separately:
```elm
-- Easy to test
encodeModel : Model -> Value
encodeModel model =
    -- Pure function, fully testable
```

Then manually verify the port integration works.

## Future Improvements

### Potential Enhancements

- **Property-based testing**: Use elm-test's fuzz testing
- **Visual regression testing**: Screenshot comparison
- **Performance benchmarks**: Track build/runtime performance
- **Accessibility testing**: Automated a11y checks
- **End-to-end tests**: Full user workflow testing
- **Test coverage metrics**: Actual line coverage reporting

### Test Gaps

Current areas with limited coverage:
- Port interactions (require manual testing)
- UI rendering (requires manual testing)
- Keyboard event handling (partially tested)
- Drag and drop (requires manual testing)
- Browser storage (requires manual testing)

## See Also

- [Build and Development Documentation](./build-and-dev.md)
- [Architecture Documentation](./architecture.md)
- [Workflow Documentation](./workflow.md) (to be created)
- [Main Agent Index](../AGENTS.md)

## Maintenance Notes

Update this document when:
- New test suites are added
- Testing strategy changes
- CI/CD test pipeline is modified
- New testing tools are introduced
- Test coverage goals change
- Manual testing procedures are formalized
