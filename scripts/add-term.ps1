# Add a term to .wordlist.txt if it doesn't already exist
# Usage: ./scripts/add-term.ps1 -Term "newterm"

param(
    [Parameter(Mandatory = $true)]
    [string]$Term
)

$wordlistPath = Join-Path $PSScriptRoot "..\\.wordlist.txt"

if (-not (Test-Path $wordlistPath)) {
    Write-Error "Wordlist file not found at $wordlistPath"
    exit 1
}

$terms = Get-Content $wordlistPath

# Check if term already exists (case insensitive)
if ($terms -match "^$Term$") {
    Write-Host "Term '$Term' already exists in wordlist"
    exit 0
}

# Add the term
Add-Content -Path $wordlistPath -Value $Term
Write-Host "Added '$Term' to wordlist"

# Sort the file alphabetically
$sortedTerms = Get-Content $wordlistPath | Sort-Object
$sortedTerms | Set-Content $wordlistPath
Write-Host "Wordlist sorted alphabetically"

# Write stats
$count = $sortedTerms.Count
Write-Host "Wordlist now contains $count terms"
