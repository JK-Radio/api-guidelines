# Test Workflows Script for JK Radio API Guidelines
# This script replicates the functionality of GitHub Actions workflows locally

function Test-MarkdownLint {
    Write-Host "✅ Running Markdown Linting..." -ForegroundColor Green
    try {
        $output = npx markdownlint "**/*.md" --ignore node_modules 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Markdown linting passed!" -ForegroundColor Green
        }
        else {
            Write-Host "❌ Markdown linting failed with the following errors:" -ForegroundColor Red
            Write-Host $output
        }
    }
    catch {
        Write-Host "❌ Error running markdownlint: $_" -ForegroundColor Red
    }
    Write-Host ""
}

function Test-LinkCheck {
    Write-Host "✅ Running Link Checking..." -ForegroundColor Green
    try {
        # First check if the script exists
        if (Test-Path -Path "./scripts/check-links.js") {
            $output = node ./scripts/check-links.js 2>&1
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ Link checking passed!" -ForegroundColor Green
            }
            else {
                Write-Host "❌ Link checking failed with the following errors:" -ForegroundColor Red
                Write-Host $output
            }
        }
        else {
            # Use find and xargs as fallback (may not work well on Windows)
            Write-Host "⚠️ Using alternative link checking method (results may vary on Windows)" -ForegroundColor Yellow
            $mdFiles = Get-ChildItem -Path "." -Recurse -Filter "*.md" | 
                Where-Object { $_.DirectoryName -notmatch "node_modules" } | 
                ForEach-Object { $_.FullName }
                
            $hasErrors = $false
            foreach ($file in $mdFiles) {
                Write-Host "Checking links in $file..."
                $output = npx markdown-link-check -c .markdown-link-check.json "$file" 2>&1
                if ($LASTEXITCODE -ne 0) {
                    $hasErrors = $true
                    Write-Host "❌ Found broken links in $file" -ForegroundColor Red
                    Write-Host $output
                }
            }
            
            if (-not $hasErrors) {
                Write-Host "✅ Link checking passed!" -ForegroundColor Green
            }
        }
    }
    catch {
        Write-Host "❌ Error running link checking: $_" -ForegroundColor Red
    }
    Write-Host ""
}

function Test-FormatMarkdown {
    Write-Host "✅ Running Markdown Formatting..." -ForegroundColor Green
    try {
        $output = npx prettier --check "**/*.md" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Markdown formatting check passed!" -ForegroundColor Green
        }
        else {
            Write-Host "❌ Some markdown files need formatting:" -ForegroundColor Yellow
            Write-Host $output
            
            $confirmFormat = Read-Host "Do you want to format these files? (y/n)"
            if ($confirmFormat -eq "y") {
                npx prettier --write "**/*.md"
                Write-Host "✅ Formatting complete!" -ForegroundColor Green
            }
        }
    }
    catch {
        Write-Host "❌ Error checking markdown formatting: $_" -ForegroundColor Red
    }
    Write-Host ""
}

function Test-RepoStructure {
    Write-Host "✅ Checking Repository Structure..." -ForegroundColor Green
    
    $requiredFiles = @("LICENSE", "CODE-OF-CONDUCT.md", "CONTRIBUTING.md", "jkradio-api-guidelines.md", "README.md")
    $missingFiles = @()
    
    foreach ($file in $requiredFiles) {
        if (-not (Test-Path -Path $file)) {
            $missingFiles += $file
        }
    }
    
    if ($missingFiles.Count -eq 0) {
        Write-Host "✅ All required files exist!" -ForegroundColor Green
    }
    else {
        Write-Host "❌ Missing required files: $($missingFiles -join ', ')" -ForegroundColor Red
    }
    Write-Host ""
}

function Test-SpellCheck {
    Write-Host "✅ Running Spell Checking..." -ForegroundColor Green
    
    # Check if Python is installed
    if (!(Get-Command python -ErrorAction SilentlyContinue)) {
        Write-Host "❌ Python is not installed or not in PATH. Spell checking requires Python." -ForegroundColor Red
        return
    }
    
    # Check if pyspelling is installed
    $pyspellingCheck = python -c "import importlib.util; print('installed' if importlib.util.find_spec('pyspelling') else 'not installed')" 2>$null
    if ($pyspellingCheck -ne "installed") {
        Write-Host "❌ pyspelling not installed. Install with: pip install pyspelling" -ForegroundColor Red
        return
    }
    
    # Check if aspell is installed
    $aspellCheck = Get-Command aspell -ErrorAction SilentlyContinue
    if (!$aspellCheck) {
        Write-Host "❌ aspell not installed. Install with Chocolatey: choco install aspell" -ForegroundColor Red
        return
    }
    
    try {
        # Run the spell check
        $output = python -m pyspelling -c .spellcheck.yml 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Spell checking passed!" -ForegroundColor Green
        }
        else {
            Write-Host "❌ Spell checking failed with the following issues:" -ForegroundColor Red
            Write-Host $output
        }
    }
    catch {
        Write-Host "❌ Error running spell check: $_" -ForegroundColor Red
    }
    Write-Host ""
}

function Show-Menu {
    Write-Host "=========================================================" -ForegroundColor Cyan
    Write-Host "    JK Radio API Guidelines Workflow Testing" -ForegroundColor Cyan
    Write-Host "=========================================================" -ForegroundColor Cyan
    Write-Host "1) Test Markdown Linting"
    Write-Host "2) Test Link Checking"
    Write-Host "3) Test Markdown Formatting"
    Write-Host "4) Test Repository Structure"
    Write-Host "5) Test Spell Checking"
    Write-Host "6) Run All Tests"
    Write-Host "Q) Quit"
    Write-Host "=========================================================" -ForegroundColor Cyan
}

# Main script
Clear-Host
Show-Menu

$choice = Read-Host "Enter your choice"

switch ($choice) {
    "1" { Test-MarkdownLint }
    "2" { Test-LinkCheck }
    "3" { Test-FormatMarkdown }
    "4" { Test-RepoStructure }
    "5" { Test-SpellCheck }
    "6" { 
        Test-MarkdownLint
        Test-LinkCheck
        Test-FormatMarkdown
        Test-RepoStructure
        Test-SpellCheck
    }
    "q" { return }
    default { Write-Host "Invalid choice. Please try again." -ForegroundColor Red }
}
