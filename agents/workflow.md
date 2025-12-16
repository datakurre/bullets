# Development Workflow Documentation

**Purpose**: Guide to development workflow, contribution process, and best practices for the bullets presentation tool.

**Last Updated**: 2024-12-16

## Overview

The bullets project follows a streamlined, task-oriented development workflow centered around the TODO.md task queue. This document describes how to work on features, commit changes, and maintain code quality.

## Development Workflow

### Task-Oriented Approach

The project uses `TODO.md` as the central task queue:

1. **Check TODO.md** for current tasks
2. **Work on one task** at a time
3. **Test changes** (unit tests or manual verification)
4. **Format code**: `make format`
5. **Commit with descriptive message**
6. **Mark task complete** in TODO.md with commit hash
7. **Do NOT commit TODO.md itself**

### Why TODO.md Is Not Committed

- `TODO.md` is agent-specific working memory
- Each agent/developer may have different task priorities
- Prevents merge conflicts on task lists
- Listed in `.gitignore`
- Acts as personal task tracker during development

### Task Completion

When completing a task:

1. **Update TODO.md** with commit hash:
   ```markdown
   * [x] Fix thumbnail scaling - Completed 6df20c7
   ```

2. **Do NOT stage/commit** TODO.md:
   ```bash
   # Good
   git add src/Main.elm
   git commit -m "Fix thumbnail scaling"
   
   # Bad - don't do this
   git add TODO.md
   ```

## Standard Development Cycle

### 1. Enter Development Environment

```bash
nix develop
```

This ensures you have all required tools available.

### 2. Start Development Server

```bash
make watch
```

Opens browser with hot-reload enabled. Edit files and see changes immediately.

### 3. Make Changes

Edit source files in your preferred editor:
- `src/` - Elm source code
- `tests/` - Test files
- `index.html` - HTML structure and CSS
- `agents/` - Agent documentation

### 4. Test Changes

**For business logic changes**:
```bash
make test
```

All tests must pass before committing.

**For UI changes**:
- Manually verify in browser
- Test keyboard shortcuts
- Check visual layout
- Try different scenarios

### 5. Format Code

```bash
make format
```

Formats all Elm files to consistent style. Run before every commit.

### 6. Commit Changes

```bash
git add <files>
git commit -m "Descriptive commit message"
```

See "Commit Messages" section for guidelines.

### 7. Push to Repository

```bash
git push origin main
```

Triggers CI/CD pipeline (tests and deployment).

## Test-Driven Development (TDD)

### TDD Workflow for New Features

**Required for business logic, optional for UI changes.**

1. **Write the test first**:
   ```elm
   test "new feature does X when Y" <|
       \_ ->
           newFeature input
               |> Expect.equal expectedOutput
   ```

2. **Run tests to see failure**:
   ```bash
   make test
   # Should fail with clear error
   ```

3. **Implement minimal code**:
   ```elm
   newFeature : Input -> Output
   newFeature input =
       -- Just enough to make test pass
   ```

4. **Run tests to see success**:
   ```bash
   make test
   # Should pass
   ```

5. **Refactor if needed**:
   - Improve code quality
   - Keep tests passing
   - Run `make format`

6. **Commit with test**:
   ```bash
   git add tests/NewFeatureTest.elm src/NewFeature.elm
   git commit -m "Add new feature with tests"
   ```

### TDD for Bug Fixes

1. **Write test that reproduces bug**:
   ```elm
   test "bug: does wrong thing in scenario X" <|
       \_ ->
           buggyFunction input
               |> Expect.equal correctOutput
   ```

2. **Verify test fails**:
   ```bash
   make test
   # Confirms bug exists
   ```

3. **Fix the bug**:
   ```elm
   buggyFunction : Input -> Output
   buggyFunction input =
       -- Fixed implementation
   ```

4. **Verify test passes**:
   ```bash
   make test
   # Bug is fixed
   ```

5. **Commit fix with test**:
   ```bash
   git commit -m "Fix bug: description of what was wrong"
   ```

## Commit Messages

### Format

```
Short summary (50 chars or less)

Optional detailed explanation if needed.
Can span multiple lines.

- Bullet points for multiple changes
- Be specific about what changed
- Reference issue numbers if applicable
```

### Good Examples

```
Add thumbnail scaling by 1.5x

Increase thumbnail size from 60x45 to 90x68 pixels to improve
visibility in the slide navigation toolbar.
```

```
Fix drag and drop visual placeholder

Add dropTargetIndex to Model and update view to show placeholder
div between slides during drag operations. Improves UX by showing
where slide will be dropped.
```

```
Add agents/testing.md - Phase 6 of refactor

Extract testing strategy documentation from AGENTS.md into
dedicated testing.md file under agents/ directory.
```

### Bad Examples

```
fix stuff
```
(Too vague, no context)

```
WIP
```
(Work in progress should not be committed)

```
Update code and tests and docs and fix bugs
```
(Too many things in one commit)

### Commit Size

- **One logical change per commit**
- Commit often, push when stable
- Don't bundle unrelated changes
- Split large changes into smaller commits

## Branching Strategy

### Current Approach

- **Main branch**: Production-ready code
- **Direct commits to main**: Small changes, well-tested
- **Feature branches**: Optional for larger features

### When to Use Branches

**Direct to main** (current practice):
- Small bug fixes
- Documentation updates
- Single-feature additions
- Changes with good test coverage

**Feature branches** (optional):
- Large refactorings
- Breaking changes
- Experimental features
- Work that needs review

### Branch Workflow (if used)

```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes and commit
git add files
git commit -m "Add new feature"

# Push branch
git push origin feature/new-feature

# Merge when ready
git checkout main
git merge feature/new-feature
git push origin main

# Delete branch
git branch -d feature/new-feature
git push origin --delete feature/new-feature
```

## Code Review (Optional)

Currently, the project uses direct commits to main. If code review is needed:

### Self-Review Checklist

Before pushing:
- [ ] Tests pass (`make test`)
- [ ] Code is formatted (`make format`)
- [ ] Commit message is descriptive
- [ ] No debug code left (Debug.log, console.log)
- [ ] Documentation updated if needed
- [ ] TODO.md updated with completion

### Peer Review (if needed)

For larger changes:
1. Create pull request
2. Describe changes clearly
3. Link to relevant issues
4. Request review from maintainer
5. Address feedback
6. Merge when approved

## Code Style

### Elm Style Guide

Follow elm-format standard:
- **Run elm-format**: `make format` before every commit
- **Explicit types**: Add type annotations to top-level functions
- **Descriptive names**: Use clear, meaningful names
- **Small functions**: Keep functions focused and short
- **Comments**: Only for complex logic, code should be self-explanatory

### Example: Good Style

```elm
-- Good: Clear name, type annotation, focused
getCurrentSlideContent : Model -> String
getCurrentSlideContent model =
    model.presentation.slides
        |> Array.fromList
        |> Array.get model.currentSlideIndex
        |> Maybe.map .content
        |> Maybe.withDefault ""
```

### Example: Bad Style

```elm
-- Bad: No type, unclear name, no formatting
f m=case List.drop m.i m.p.s of
  x::_->x.c
  _->""
```

### CSS Style

In `index.html`:
- **Consistent naming**: Use kebab-case for classes
- **Organized sections**: Group related styles
- **Comments**: Mark major sections
- **Specific selectors**: Avoid overly broad selectors
- **No !important**: Except when absolutely necessary

## Documentation

### When to Update Docs

Update documentation when:
- **Adding features**: Document in AGENTS.md or agents/
- **Changing architecture**: Update agents/architecture.md
- **Changing build process**: Update agents/build-and-dev.md
- **Changing workflow**: Update this file (agents/workflow.md)
- **Adding dependencies**: Update agents/dependencies.md

### Documentation Types

**Agent Documentation** (`AGENTS.md`, `agents/`):
- For LLM agents and developers
- Technical details and architecture
- Development processes
- Keep updated with code changes

**User Documentation** (`README.md`):
- For end users
- How to use the application
- Feature overview
- Keep minimal and user-focused

**Code Comments**:
- Only for complex logic
- Explain "why", not "what"
- Keep updated with code
- Remove when code becomes clear

### Documentation Standards

- **Keep it current**: Update with code changes
- **Be specific**: Include examples and details
- **Link related docs**: Cross-reference other files
- **Version it**: Include "Last Updated" dates
- **Explain rationale**: Document why decisions were made

## Error Handling

### Compilation Errors

Elm's compiler provides excellent error messages:

1. **Read the error carefully**: Elm explains what's wrong
2. **Check the hint**: Compiler often suggests fixes
3. **Fix one error at a time**: Start with the first error
4. **Rebuild**: `make build` or let `make watch` rebuild

### Test Failures

When tests fail:

1. **Read test output**: See what failed and why
2. **Locate the test**: Find the failing test file
3. **Understand expected behavior**: Review test description
4. **Debug**: Add Debug.log if needed
5. **Fix**: Update code or test
6. **Verify**: Run tests again

### Runtime Errors

If you encounter runtime errors:

1. **Check browser console**: Look for JavaScript errors
2. **Check Elm debug**: Look for Elm runtime errors
3. **Reproduce**: Find minimal steps to trigger error
4. **Write test**: Create failing test if possible
5. **Fix**: Update code to handle case
6. **Verify**: Test manually and with unit tests

## Working with Ports

### Port Development Process

Ports connect Elm to JavaScript. Special considerations:

1. **Define port in Elm**:
   ```elm
   port saveToLocalStorage : Value -> Cmd msg
   ```

2. **Implement in JavaScript** (index.html):
   ```javascript
   app.ports.saveToLocalStorage.subscribe(function(data) {
       localStorage.setItem('bullets', JSON.stringify(data));
   });
   ```

3. **Test encoder/decoder separately**:
   ```elm
   -- Test pure encode function
   test "encodeModel creates valid JSON" <|
       \_ ->
           encodeModel model
               |> Decode.decodeValue decodeModel
               |> Expect.ok
   ```

4. **Manual test port integration**:
   - Open browser console
   - Trigger port
   - Verify JavaScript behavior
   - Check storage/network/etc.

### Port Best Practices

- **Keep ports simple**: One clear purpose per port
- **Test pure functions**: Separate business logic from ports
- **Document port contracts**: Explain data format
- **Handle errors**: JavaScript side should catch errors
- **Minimize ports**: Use Elm as much as possible

## Continuous Integration

### GitHub Actions Pipeline

On every push to main:

1. **Test Job**: Runs `elm-test`
   - Must pass before deployment
   - Blocks if any test fails

2. **Build Job**: Compiles production bundle
   - Downloads vendor libraries
   - Builds optimized elm.js
   - Creates deployment artifact

3. **Deploy Job**: Publishes to GitHub Pages
   - Deploys _site/ directory
   - Updates production site
   - Provides deployment URL

### Fixing CI Failures

If CI fails:

1. **Check GitHub Actions tab**: View job logs
2. **Identify failing job**: Test, Build, or Deploy
3. **Reproduce locally**:
   ```bash
   make test      # For test failures
   make build     # For build failures
   ```
4. **Fix the issue**
5. **Verify locally**: Ensure it works
6. **Push fix**: CI will run again

## Shell Command Guidelines

### Command Chaining

**DO NOT** chain commands with `&&`:

```bash
# Bad - Don't do this
make build && make test && git commit

# Good - Separate commands
make build
make test
git commit
```

**Reason**: Task management requires separate command execution for proper tracking and error handling.

### Command Execution

Use Makefile targets when available:

```bash
# Good - Use make targets
make build
make test
make format

# Less good - Direct commands (but acceptable)
elm make src/Main.elm --output=elm.js
elm-test
elm-format --yes src/
```

## Task Management

### TODO Files

- **TODO.md**: Main task queue (not committed)
- **TODO-*.md**: Sub-task files for complex features (not committed)
- **agents/**: Agent documentation (committed)

### Working with TODO.md

1. **Check for tasks**: Review TODO.md at start
2. **Pick one task**: Work on one thing at a time
3. **Complete task**: Test, format, commit
4. **Mark complete**: Update TODO.md with commit hash
5. **Move to next**: Repeat process

### Complex Features

For large features, create sub-TODO files:

```bash
# Create sub-task file
echo "# TODO-NEW-FEATURE" > TODO-NEW-FEATURE.md

# Reference from TODO.md
echo "* [ ] TODO-NEW-FEATURE.md" >> TODO.md

# Work through sub-tasks
# When complete, mark main task done
```

### Completed Tasks

Keep completed tasks in TODO.md:
- Provides history
- Shows progress
- Reference for future work
- Include commit hashes

## LLM Agent Guidelines

### For AI Agents

When working on this codebase:

1. **Read TODO.md first**: Understand current tasks
2. **Follow TDD**: Write tests for business logic
3. **One task at a time**: Complete fully before moving on
4. **Test before commit**: Always verify changes work
5. **Update TODO.md**: Mark completion with commit hash
6. **Never commit TODO.md**: Keep it as working memory
7. **Update agent docs**: Keep AGENTS.md and agents/ current
8. **Use nix environment**: All commands in `nix develop`

### Agent Workflow

```
1. Read TODO.md → Pick task
2. Read relevant docs (AGENTS.md, agents/)
3. Write test (if applicable)
4. Implement feature
5. Run tests
6. Format code
7. Commit with clear message
8. Update TODO.md with commit hash
9. Update agent docs if needed
10. Move to next task
```

## Best Practices Summary

- ✅ Work on one task at a time
- ✅ Write tests for business logic (TDD)
- ✅ Run `make format` before committing
- ✅ Run `make test` before committing
- ✅ Commit with descriptive messages
- ✅ Update TODO.md with commit hashes
- ✅ Keep agent documentation current
- ✅ Use nix development environment
- ❌ Don't commit TODO.md
- ❌ Don't chain commands with &&
- ❌ Don't commit without testing
- ❌ Don't bundle unrelated changes

## See Also

- [Build and Development Documentation](./build-and-dev.md)
- [Testing Documentation](./testing.md)
- [Architecture Documentation](./architecture.md)
- [Dependencies Documentation](./dependencies.md) (to be created)
- [Main Agent Index](../AGENTS.md)

## Maintenance Notes

Update this document when:
- Development workflow changes
- New tools are introduced
- Task management process evolves
- Commit conventions change
- CI/CD pipeline is modified
- Best practices are refined
