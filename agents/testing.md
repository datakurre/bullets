# Testing Documentation

**Purpose**: Comprehensive guide to testing strategy, test organization, and quality assurance for the bullets presentation tool.

**Last Updated**: 2024-12-16

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

- **72 unit tests** covering core functionality
- **All tests passing** in CI/CD pipeline
- Focus areas:
  - JSON serialization/deserialization (round-trip correctness)
  - Navigation logic (boundary conditions, state transitions)
  - Slide manipulation (add, delete, duplicate, reorder)

## Test-Driven Development (TDD)

### TDD Enforcement

**ENFORCE TDD** for all new features and bug fixes that involve business logic.

### TDD Workflow

1. **Write the test first**: Before implementing any new logic, write a failing test that describes the desired behavior
2. **Run tests to confirm failure**: Verify the test fails for the right reason (`make test`)
3. **Implement the minimal code**: Write just enough code to make the test pass
4. **Run tests to confirm success**: Verify all tests pass (`make test`)
5. **Refactor if needed**: Improve the code while keeping tests green
6. **Format code**: Run `make format` before committing

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
├── JsonTest.elm              # JSON encoding/decoding tests
├── NavigationTest.elm        # Navigation logic tests
└── SlideManipulationTest.elm # Slide manipulation tests
```

### File Naming Convention

- Test files match source module names with `Test` suffix
- Example: `src/Json.elm` → `tests/JsonTest.elm`
- Place tests in `tests/` directory at same hierarchy level

### Test Structure

Tests use `elm-test` with `describe`/`test` structure:

```elm
module NavigationTest exposing (..)

import Expect
import Test exposing (..)
import Navigation exposing (..)

suite : Test
suite =
    describe "Navigation"
        [ describe "nextSlideIndex"
            [ test "moves to next slide when not at end" <|
                \_ ->
                    nextSlideIndex 0 3
                        |> Expect.equal 1
            
            , test "stays at last slide when at end" <|
                \_ ->
                    nextSlideIndex 2 3
                        |> Expect.equal 2
            ]
        ]
```

### Test Naming

- **Describe blocks**: Name the function or feature being tested
- **Test names**: Use descriptive phrases that explain the scenario
- Format: "does X when Y" or "returns Z for input W"
- Be specific about edge cases

Good examples:
- ✅ "moves to next slide when not at end"
- ✅ "stays at last slide when at end"
- ✅ "wraps to first slide in presentation mode"

Bad examples:
- ❌ "test 1"
- ❌ "works correctly"
- ❌ "navigation"

## Test Suites

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

Duration: 123 ms
Passed:   72
Failed:   0
```

Failed test:
```
TEST RUN FAILED

Duration: 145 ms
Passed:   71
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
- **Total tests**: 72
- **Pass rate**: 100%
- **Test execution time**: ~3-5 seconds

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
