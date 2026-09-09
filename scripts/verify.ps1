# RankBrum Hermes Blueprint Verification Script
# This script verifies dependencies and configuration

<#
.SYNOPSIS
    Verifies a Hermes installation against the RankBrum AI blueprint

.DESCRIPTION
    This script checks that a Hermes installation has the necessary components
    configured according to the RankBrum AI blueprint. It verifies directory
    structures, installed skills, configured providers, and other key elements.

.PARAMETER WorkspaceRoot
    The root directory for the Hermes installation (default: $env:LOCALAPPDATA\hermes)

.PARAMETER MemoryRoot
    The root directory for Memory Core storage (default: C:\RankBrum\MemoryCore)

.EXAMPLE
    .\verify.ps1 -WorkspaceRoot "C:\hermes" -MemoryRoot "D:\MemoryCore"

.NOTES
    This script performs read-only verification and does not modify any files.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$WorkspaceRoot = "$env:LOCALAPPDATA\hermes",
    
    [Parameter(Mandatory=$false)]
    [string]$MemoryRoot = "C:\RankBrum\MemoryCore"
)

Write-Host "RankBrum Hermes Blueprint Verification" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Initialize results
$results = @{}
$passed = 0
$failed = 0

function Test-Requirement {
    param(
        [string]$Description,
        [bool]$Result
    )
    
    if ($Result) {
        Write-Host "[PASS] $Description" -ForegroundColor Green
        $passed++
        $results[$Description] = "PASS"
    } else {
        Write-Host "[FAIL] $Description" -ForegroundColor Red
        $failed++
        $results[$Description] = "FAIL"
    }
}

# Check Hermes Installation
Write-Host "Checking Hermes Installation..." -ForegroundColor Yellow
Write-Host "--------------------------------" -ForegroundColor Yellow

$hermesExists = Test-Path $WorkspaceRoot
Test-Requirement "Hermes installation directory exists" $hermesExists

if ($hermesExists) {
    $configExists = Test-Path (Join-Path $WorkspaceRoot "config.yaml")
    Test-Requirement "config.yaml exists" $configExists
    
    $skillsDirExists = Test-Path (Join-Path $WorkspaceRoot "skills")
    Test-Requirement "skills directory exists" $skillsDirExists
    
    $memoriesDirExists = Test-Path (Join-Path $WorkspaceRoot "memories")
    Test-Requirement "memories directory exists" $memoriesDirExists
    
    $mcpTokensDirExists = Test-Path (Join-Path $WorkspaceRoot "mcp-tokens")
    Test-Requirement "mcp-tokens directory exists" $mcpTokensDirExists
}

# Check Memory Core
Write-Host ""
Write-Host "Checking Memory Core..." -ForegroundColor Yellow
Write-Host "-----------------------" -ForegroundColor Yellow

$memoryRootExists = Test-Path $MemoryRoot
Test-Requirement "Memory Core directory exists" $memoryRootExists

if ($memoryRootExists) {
    # Check for expected subdirectories
    $expectedSubdirs = @(
        "00_SYSTEM", "01_CONVERSATIONS", "02_PROJECTS", "03_DECISIONS",
        "04_KNOWLEDGE", "05_AGENTS", "06_PROMPTS", "07_LEARNINGS",
        "08_RAW", "09_DATABASE", "10_INBOX", "11_ARCHIVE"
    )
    
    foreach ($subdir in $expectedSubdirs) {
        $dirPath = Join-Path $MemoryRoot $subdir
        $dirExists = Test-Path $dirPath
        Test-Requirement "Memory Core subdirectory: $subdir" $dirExists
    }
}

# Check for RankBrum Skills
Write-Host ""
Write-Host "Checking RankBrum Skills..." -ForegroundColor Yellow
Write-Host "---------------------------" -ForegroundColor Yellow

if (Test-Path (Join-Path $WorkspaceRoot "skills")) {
    $rankbrumSkills = @(
        "rankbrum-ceo",
        "rankbrum-cto",
        "rankbrum-project-manager",
        "rankbrum-ui-ux",
        "rankbrum-frontend",
        "rankbrum-backend",
        "rankbrum-qa",
        "rankbrum-browser-qa",
        "rankbrum-pipeline-analysis",
        "rankbrum-pipeline-architecture",
        "rankbrum-execution-governance",
        "rankbrum-figma-governance"
    )
    
    foreach ($skill in $rankbrumSkills) {
        $skillPath = Join-Path $WorkspaceRoot "skills" $skill
        $skillExists = Test-Path $skillPath
        Test-Requirement "RankBrum skill installed: $skill" $skillExists
    }
}

# Check for .env.example
Write-Host ""
Write-Host "Checking Configuration Files..." -ForegroundColor Yellow
Write-Host "------------------------------" -ForegroundColor Yellow

$envExampleExists = Test-Path (Join-Path $PSScriptRoot ".." ".env.example")
Test-Requirement ".env.example exists" $envExampleExists

$gitIgnoreExists = Test-Path (Join-Path $PSScriptRoot ".." ".gitignore")
Test-Requirement ".gitignore exists" $gitIgnoreExists

$providersExampleExists = Test-Path (Join-Path $PSScriptRoot ".." "configs" "providers.example.yaml")
Test-Requirement "providers.example.yaml exists" $providersExampleExists

# Summary
Write-Host ""
Write-Host "Verification Summary" -ForegroundColor Cyan
Write-Host "===================" -ForegroundColor Cyan
Write-Host "Passed: $passed" -ForegroundColor Green
Write-Host "Failed: $failed" -ForegroundColor Red
Write-Host "Total:  $($passed + $failed)" -ForegroundColor White

if ($failed -eq 0) {
    Write-Host ""
    Write-Host "All verification checks passed!" -ForegroundColor Green
    Write-Host "Your installation appears to be ready for RankBrum Hermes blueprint application." -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Copy .env.example to .env and add your actual API keys" -ForegroundColor Yellow
    Write-Host "2. Configure your providers in Hermes Settings → Providers" -ForegroundColor Yellow
    Write-Host "3. Set up your Memory Core at $MemoryRoot" -ForegroundColor Yellow
    Write-Host "4. Configure MCP servers (Figma, Hugging Face) in Hermes Settings → MCP" -ForegroundColor Yellow
    Write-Host "5. Follow the REPLICATION_GUIDE.md for detailed configuration steps" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "Some verification checks failed." -ForegroundColor Red
    Write-Host "Please review the failed items above and address them before proceeding." -ForegroundColor Red
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "- Hermes not installed at expected location" -ForegroundColor Yellow
    Write-Host("- Memory Core directory structure not created" -ForegroundColor Yellow)
    Write-Host("- RankBrum skills not installed" -ForegroundColor Yellow)
    Write-Host("- Missing example configuration files" -ForegroundColor Yellow)
}

exit $failed