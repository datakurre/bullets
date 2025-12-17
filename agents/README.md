# Agent Documentation

This directory contains detailed documentation for LLM agents working on the bullets project.

## Purpose

The `./agents/` directory provides modular, focused documentation that supplements the main [AGENTS.md](../AGENTS.md) file. While AGENTS.md provides a high-level overview and quick reference, documents in this directory contain detailed architectural decisions, implementation guides, and specialized topics.

## Documentation Index

### Core Architecture

- **[architecture.md](./architecture.md)** - System architecture, data model, message types, and view organization
- **[data-model.md](./data-model.md)** - Detailed type definitions, JSON encoding/decoding, and data structures
- **[ui-components.md](./ui-components.md)** - View hierarchy, component organization, and UI patterns

### Development Process

- **[build-and-dev.md](./build-and-dev.md)** - Development environment setup, build system, Makefile, CI/CD pipeline
- **[testing.md](./testing.md)** - Testing strategy, TDD workflow, test organization, coverage reporting
- **[workflow.md](./workflow.md)** - Development workflow, task management, commit conventions, best practices
- **[dependencies.md](./dependencies.md)** - All dependencies (Elm packages, vendor libraries, dev tools) with rationale

### Design Decisions

- **[adr/](./adr/)** - Architecture Decision Records documenting key design choices
  - [001: VIM Keybindings](./adr/001-vim-keybindings.md)

## How to Use

When working on the bullets project:

1. **Start with** [AGENTS.md](../AGENTS.md) for project overview and quick reference
2. **Read relevant docs** from the list above based on your task:
   - Working on architecture? Read architecture.md and data-model.md
   - Setting up development? Read build-and-dev.md
   - Writing tests? Read testing.md and workflow.md
   - Adding dependencies? Read dependencies.md
3. **Check ADRs** in `adr/` to understand past design decisions
4. **Follow cross-references** - each doc links to related documentation

## Documentation Guidelines

### For Document Authors

- **Single focus**: Each document covers one topic area
- **Cross-reference**: Link to related docs with brief context
- **Update dates**: Include "Last Updated" date in each doc
- **Examples**: Provide concrete code examples
- **Maintenance notes**: Document what triggers updates
- **See Also**: Include "See Also" section linking related docs

### For Document Consumers

- **Start broad**: Begin with AGENTS.md overview
- **Go deep**: Follow links to detailed documentation
- **Check dates**: Verify information is current
- **Update docs**: If you find outdated info, update it
- **Add examples**: Contribute examples based on your experience

## Maintenance

Update this README when:
- New documentation files are added
- Documentation structure changes
- File purposes change
- Cross-reference patterns evolve

Last Updated: 2024-12-16

