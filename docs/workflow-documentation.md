# API Guidelines Documentation Maintenance

This documentation outlines how the GitHub Actions workflows maintain the quality of the JK Radio
API Guidelines.

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
- Uses a custom script to check each markdown file individually

**When it runs:**

- On push to main/master branch for markdown files
- On pull requests for markdown files
- Weekly on Monday at 08:00 UTC
- Manually via workflow dispatch

### Spell Checking (`spell-check.yml`)

This workflow uses PySpelling to catch spelling errors in documentation.

**Configuration:** `.spellcheck.yml` and `.wordlist.txt`

**Key Features:**

- Uses `aspell` with English dictionary
- Filters to ignore code blocks and HTML elements
- Maintains a custom wordlist of technical terms
- Supports both GitHub-specific and programming terms

**Managing Technical Terms:**

To add new technical terms, simply update the `.wordlist.txt` file with:
1. One term per line
2. Include both lowercase and uppercase variants if needed
3. Add common abbreviations and acronyms
4. Include product names, tools, and framework terms

**When it runs:**

- On push to main/master branch for markdown files
- On pull requests for markdown files
- Manually via workflow dispatch

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

## Local Development & Testing

### Using npm scripts

The repository includes npm scripts for running the same checks locally:

```powershell
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

### Using the Test Script

For a more interactive approach, you can use the PowerShell test script:

```powershell
# Run the interactive test script
./scripts/test-workflows.ps1
```

This script provides a menu-driven interface to test individual workflows or all of them together.

### Using act to test GitHub Actions locally

For a full simulation of GitHub Actions workflows, you can use [act](https://github.com/nektos/act),
a tool that allows you to run GitHub Actions locally using Docker:

1. Install Docker Desktop for Windows
2. Install act: `npm install -g @nektos/act` or `choco install act-cli`
3. Run workflows locally:

```powershell
# List available workflows
act -l

# Run a specific workflow
act -j markdown-lint

# Run a workflow with a specific trigger
act push -j check-links

# Run a workflow manually (workflow_dispatch)
act workflow_dispatch -j format
```

This provides the most accurate simulation of how the workflows will run on GitHub.
