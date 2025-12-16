# Bullets

A minimal browser-based presentation tool with edit and presentation modes.

## Features

- **Edit Mode**: Manage slides and edit content in Markdown
- **Presentation Mode**: Full-screen presentations with keyboard navigation
- **Multiple Layouts**: Title only, markdown, or markdown with image
- **Image Support**: Paste images from clipboard or upload from filesystem
- **Auto-save**: Automatic save/load to browser's local storage
- **Export/Import**: Download and load presentations as JSON files
- **Markdown Rendering**: Live preview and rendered presentations

## Quick Start

### Development

```bash
# Start development server with live reload
make watch

# Build optimized production bundle
make build

# Format Elm source files
make format

# Clean build artifacts
make clean
```

### Using Nix

This project includes a Nix flake for reproducible development environment:

```bash
nix develop
```

## Keyboard Shortcuts

### Presentation Mode
- **Arrow Keys / Space / Enter**: Navigate slides
- **ESC**: Exit presentation mode

## GitHub Pages Deployment

This project is configured to automatically deploy to GitHub Pages when changes are pushed to the main branch.

To enable GitHub Pages:
1. Go to your repository Settings
2. Navigate to Pages section
3. Under "Build and deployment", select "GitHub Actions" as the source

The site will be available at: `https://<username>.github.io/<repository>/`

## License

BSD-3-Clause
