# API Guidelines Documentation Maintenance

This documentation outlines how the GitHub Actions workflows maintain the quality of the JK Radio API Guidelines.

## Workflow Details

### Markdown Lint (`markdown-lint.yml`)

This workflow uses `markdownlint-cli` to validate markdown formatting and structure.

**Configuration:** `.markdownlint.json`

**Key Rules:**
- Maximum line length: 120 characters
- Consistent headings
- Proper spacing
- Correct list formatting

**When it runs:**
- On push to main/master branch for markdown files
- On pull requests for markdown files
- Manually via workflow dispatch

### Link Checking (`check-links.yml`)

This workflow verifies that all links in the markdown files are valid and working.

**Configuration:** `.markdown-link-check.json`

**Key Features:**
- Ignores internal domain links (configurable)
- Retries on 429 errors (too many requests)
- Weekly scheduled run to catch links that become broken over time

**When it runs:**
- On push to main/master branch for markdown files
- On pull requests for markdown files
- Weekly on Monday at 08:00 UTC
- Manually via workflow dispatch

### Spell Checking (`spell-check.yml`)

This workflow uses PySpelling to catch spelling errors in documentation.

**Configuration:** `.spellcheck.yml` and `.wordlist.txt`

**Key Features:**
- Checks spelling in markdown files
- Uses a custom dictionary for technical terms
- Ignores code blocks

**When it runs:**
- On push to main/master branch for markdown files
- On pull requests for markdown files
- Manually via workflow dispatch

### Repository Structure Check (`repo-check.yml`)

This workflow validates the repository structure and ensures required files exist.

**Key Features:**
- Checks for essential files (LICENSE, CODE-OF-CONDUCT.md, etc.)
- Creates a README.md if one doesn't exist

**When it runs:**
- On push to main/master branch
- On pull requests to main/master branch
- Manually via workflow dispatch

### Markdown Formatting (`format-markdown.yml`)

This workflow automatically formats markdown files using Prettier.

**Configuration:** `.prettierrc`

**Key Features:**
- Ensures consistent formatting
- Auto-commits changes to the pull request branch

**When it runs:**
- On pull requests for markdown files
- Manually via workflow dispatch

## Adding Custom Words to Spell Check

To add technical terms or proper nouns to the spell checker's dictionary:

1. Edit the `.wordlist.txt` file
2. Add each word on a new line
3. Commit and push the changes

## Customizing Workflows

These workflows can be customized by editing the configuration files:

- Markdown linting rules: `.markdownlint.json`
- Link checking rules: `.markdown-link-check.json`
- Spell checking rules: `.spellcheck.yml` and `.wordlist.txt`
- Formatting rules: `.prettierrc`

## Local Development

The repository includes npm scripts for running the same checks locally:

```bash
# Install dependencies
npm install

# Run markdown linting
npm run lint:md

# Check links
npm run check:links

# Format markdown files
npm run format
```

These scripts are defined in the `package.json` file and can be customized as needed.
