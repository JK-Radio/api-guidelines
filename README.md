# JK Radio API Guidelines

This repository contains the official API guidelines for JK Radio. These guidelines ensure
consistency, security, and usability across all JK Radio APIs, while promoting an API-first approach
to development.

## Contents

- [API Guidelines](jkradio-api-guidelines.md) - Comprehensive guidelines for developing, securing,  
  and publishing APIs within the JK Radio organization
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

```powershell
# Install local development dependencies
npm install

# Run markdown linting
npm run lint:md

# Check links
npm run check:links

# Format markdown files
npm run format

# Run spell check (requires Python and dependencies)
# pip install pyspelling
# sudo apt-get install aspell aspell-en (Linux)
# choco install aspell (Windows with Chocolatey)
# brew install aspell (macOS with Homebrew)
npm run spell-check
```

### Managing Technical Terms for Spell Checking

The spell-check workflow uses a custom wordlist (`.wordlist.txt`) to recognize technical terms  
that aren't in standard dictionaries. To add new technical terms:

1. Edit the `.wordlist.txt` file in the repository root
2. Add one term per line
3. Include both lowercase and uppercase variants if needed
4. Commit the changes to your branch

Technical terms already included: npm, npx, md, PowerShell, GitHub, API, and many common  
programming terms.

### Testing Workflows Locally

You can test the GitHub Actions workflows locally:

1. **Interactive Test Script**:

   ```powershell
   # Interactive menu to test workflows
   ./scripts/test-workflows.ps1
   ```

2. **Using act** (requires Docker):

   ```powershell
   # Install act
   npm install -g @nektos/act

   # Run a specific workflow
   act -j markdown-lint
   ```

For more details, see the [workflow documentation](docs/workflow-documentation.md).

### Direct NPX Commands

You can also run checks directly with npx:

```powershell
# Run markdown linting
npx markdownlint **/*.md --ignore node_modules

# Check links
node scripts/check-links.js

# Format markdown files
npx prettier --write "**/*.md"
```

## License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.

---

© 2025 JK Radio. All rights reserved.
