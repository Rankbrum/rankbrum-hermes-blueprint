# RankBrum Hermes Blueprint Installation Script
# This script prepares a new installation

<#
.SYNOPSIS
    Prepares a new Hermes installation for RankBrum AI blueprint replication

.DESCRIPTION
    This script helps set up a new Hermes installation according to the RankBrum AI blueprint.
    It creates necessary directory structures, copies example configurations, and sets up
    the environment for applying the blueprint.

.PARAMETER WorkspaceRoot
    The root directory for the Hermes installation (default: $env:LOCALAPPDATA\hermes)

.PARAMETER MemoryRoot
    The root directory for Memory Core storage (default: C:\RankBrum\MemoryCore)

.EXAMPLE
    .\install.ps1 -WorkspaceRoot "C:\hermes" -MemoryRoot "D:\MemoryCore"

.NOTES
    This script does not modify existing Hermes installations or overwrite configurations.
    It only prepares the environment for blueprint application.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$WorkspaceRoot = "$env:LOCALAPPDATA\hermes",
    
    [Parameter(Mandatory=$false)]
    [string]$MemoryRoot = "C:\RankBrum\MemoryCore"
)

Write-Host "RankBrum Hermes Blueprint Installation Preparation" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Validate paths
if (-not (Test-Path $WorkspaceRoot)) {
    Write-Warning "Workspace root '$WorkspaceRoot' does not exist. Creating it..."
    New-Item -ItemType Directory -Path $WorkspaceRoot -Force | Out-Null
}

if (-not (Test-Path $MemoryRoot)) {
    Write-Warning "Memory root '$MemoryRoot' does not exist. Creating directory structure..."
    New-Item -ItemType Directory -Path $MemoryRoot -Force | Out-Null
    
    # Create Memory Core subdirectories
    $subdirs = @(
        "00_SYSTEM", "01_CONVERSATIONS", "02_PROJECTS", "03_DECISIONS",
        "04_KNOWLEDGE", "05_AGENTS", "06_PROMPTS", "07_LEARNINGS",
        "08_RAW", "09_DATABASE", "10_INBOX", "11_ARCHIVE"
    )
    
    foreach ($dir in $subdirs) {
        New-Item -ItemType Directory -Path (Join-Path $MemoryRoot $dir) -Force | Out-Null
    }
    
    Write-Host "Created Memory Core directory structure at $MemoryRoot" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installation preparation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Install Hermes Agent from official source" -ForegroundColor Yellow
Write-Host "2. Clone the rankbrum-hermes-blueprint repository" -ForegroundColor Yellow
Write-Host "3. Run the verification script: .\scripts\verify.ps1" -ForegroundColor Yellow
Write-Host "4. Follow the REPLICATION_GUIDE.md for detailed configuration steps" -ForegroundColor Yellow
Write-Host ""
Write-Host "Important:" -ForegroundColor Yellow
Write-Host "- Never commit .env files or MCP tokens to version control" -ForegroundColor Yellow
Write-Host "- Replace placeholder values in .env.example with actual API keys" -ForegroundColor Yellow
Write-Host "- Follow all governance principles documented in the blueprint" -ForegroundColor Yellow