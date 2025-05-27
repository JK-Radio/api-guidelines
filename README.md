# JK Radio API Guidelines

This repository contains the official API guidelines for JK Radio. These guidelines ensure consistency, security, and usability across all JK Radio APIs, while promoting an API-first approach to development.

## Contents

- [API Guidelines](jkradio-api-guidelines.md) - Comprehensive guidelines for developing, securing, and publishing APIs within the JK Radio organization
- [Contributing](CONTRIBUTING.md) - Information for contributors
- [Code of Conduct](CODE-OF-CONDUCT.md) - Community guidelines for contributors

## Automated Workflows

This repository uses several GitHub Actions workflows to maintain quality:

- **Markdown Linting** - Ensures all markdown files follow consistent formatting rules
- **Link Checking** - Validates that all links in the documentation are working correctly
- **Spell Checking** - Catches spelling errors and typos in documentation
- **Repository Structure Validation** - Ensures the repository maintains the required structure
- **Markdown Formatting** - Automatically formats markdown files on pull requests

## Development

To contribute to this project:

1. Fork this repository
2. Make your changes in a feature branch
3. Submit a pull request

Before submitting, please ensure your changes pass all automated checks by running:

```bash
# Install local development dependencies
npm install

# Run markdown linting
npm run lint:md

# Check links
npm run check:links

# Format markdown files
npm run format
```

Alternatively, you can run these checks directly with npx:

```bash
# Run markdown linting
npx markdownlint '**/*.md' --ignore node_modules

# Check links
npx markdown-link-check -c .markdown-link-check.json **/*.md

# Format markdown files
npx prettier --write "**/*.md"
```

## License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.

---

© 2025 JK Radio. All rights reserved.
