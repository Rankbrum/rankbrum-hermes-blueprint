# RankBrum Hermes Blueprint Backup Script
# This script backs up allowed configurations

<#
.SYNOPSIS
    Backs up allowed Hermes configurations for RankBrum AI blueprint

.DESCRIPTION
    This script creates a backup of allowed Hermes configurations that can be safely
    version controlled. It excludes secrets, credentials, and sensitive data while
    preserving the structural and configuration elements needed for replication.

.PARAMETER WorkspaceRoot
    The root directory for the Hermes installation (default: $env:LOCALAPPDATA\hermes)

.PARAMETER BackupDir
    The directory where backups should be stored (default: ./backup)

.EXAMPLE
    .\backup.ps1 -WorkspaceRoot "C:\hermes" -BackupDir "./hermes_backup"

.NOTES
    This script only backs up non-sensitive configuration files and directories.
    It does not backup:
    - .env files (contain API keys)
    - MCP token files (contain authentication credentials)
    - auth.json (contains authentication data)
    - Logs (may contain sensitive information)
    - Cache directories (may contain temporary sensitive data)
    - Session dumps (may contain sensitive request data)
    - State databases (may contain sensitive information)
    - Memory Core (contains user data and conversations)
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)]
    [string]$WorkspaceRoot = "$env:LOCALAPPDATA\hermes",
    
    [Parameter(Mandatory=$false)]
    [string]$BackupDir = "./backup"
)

Write-Host "RankBrum Hermes Blueprint Backup" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Validate paths
if (-not (Test-Path $WorkspaceRoot)) {
    Write-Error "Workspace root '$WorkspaceRoot' does not exist."
    exit 1
}

# Create backup directory if it doesn't exist
if (-not (Test-Path $BackupDir)) {
    New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
    Write-Host "Created backup directory: $BackupDir" -ForegroundColor Green
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$backupPath = Join-Path $BackupDir "hermes_backup_$timestamp"
New-Item -ItemType Directory -Path $backupPath -Force | Out-Null

Write-Host "Backing up to: $backupPath" -ForegroundColor Yellow
Write-Host ""

# Define what to backup (non-sensitive files and directories)
$itemsToBackup = @(
    # Configuration files (template/examples only)
    @{ Source = "config.yaml.example"; Dest = "configs/" },
    @{ Source = "providers.example.yaml"; Dest = "configs/" },
    
    # Documentation and blueprint files
    @{ Source = "README.md"; Dest = "" },
    @{ Source = "ARCHITECTURE.md"; Dest = "" },
    @{ Source = "INSTALLATION.md"; Dest = "" },
    @{ Source = "REPLICATION_GUIDE.md"; Dest = "" },
    @{ Source = "TROUBLESHOOTING.md"; Dest = "" },
    @{ Source = "CHANGELOG.md"; Dest = "" },
    
    # Skills documentation (we'll copy the skill structure but not necessarily all skills)
    @{ Source = "docs/"; Dest = "docs/" },
    @{ Source = "scripts/"; Dest = "scripts/" },
    
    # Example files
    @{ Source = ".env.example"; Dest = "" },
    @{ Source = ".gitignore"; Dest = "" }
)

# Copy blueprint documentation and scripts
Write-Host "Backing up blueprint documentation and scripts..." -ForegroundColor Yellow
foreach ($item in $itemsToBackup) {
    $sourcePath = Join-Path $PSScriptRoot ".." $item.Source
    $destPath = Join-Path $backupPath $item.Dest
    
    if (Test-Path $sourcePath) {
        if (Test-Path $sourcePath -PathType Container) {
            # Copy directory
            Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force
            Write-Host "  Copied directory: $($item.Source)" -ForegroundColor Green
        } else {
            # Copy file
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            Write-Host "  Copied file: $($item.Source)" -ForegroundColor Green
        }
    } else {
        Write-Warning "Source not found: $sourcePath"
    }
}

# Backup skills structure (just the skill names and basic info, not full content)
Write-Host ""
Write-Host "Backing up skills structure..." -ForegroundColor Yellow
$skillsBackupPath = Join-Path $backupPath "skills_structure"
New-Item -ItemType Directory -Path $skillsBackupPath -Force | Out-Null

if (Test-Path (Join-Path $WorkspaceRoot "skills")) {
    Get-ChildItem -Path (Join-Path $WorkspaceRoot "skills") -Directory | ForEach-Object {
        $skillName = $_.Name
        $skillInfoPath = Join-Path $skillsBackupPath "$skillName.md"
        
        # Create a simple info file for each skill
        @"
# $skillName
Source: $($_.FullName)
LastBackup: $(Get-Date -Format u)
"@ | Out-File -FilePath $skillInfoPath -Encoding UTF8
        
        Write-Host "  Backed up skill info: $skillName" -ForegroundColor Green
    }
}

# Backup MCP structure (just server names, not tokens)
Write-Host ""
Write-Host "Backing up MCP structure..." -ForegroundColor Yellow
$mcpBackupPath = Join-Path $backupPath "mcp_structure"
New-Item -ItemType Directory -Path $mcpBackupPath -Force | Out-Null

if (Test-Path (Join-Path $WorkspaceRoot "mcp-tokens")) {
    # Just backup that the directory exists and list what servers we know about from config
    $mcpInfoPath = Join-Path $mcpBackupPath "mcp_servers_info.md"
    @"
# MCP Servers Structure
Source: $((Join-Path $WorkspaceRoot "mcp-tokens").FullName)
LastBackup: $(Get-Date -Format u)

Known MCP Servers (from audited installation):
- figma
- hugging_face

Note: Actual MCP tokens are NOT backed up for security reasons.
To restore MCP access, you must re-authenticate each server in Hermes.
"@ | Out-File -FilePath $mcpInfoPath -Encoding UTF8
    
    Write-Host "  Backed up MCP structure info" -ForegroundColor Green
}

# Create backup manifest
Write-Host ""
Write-Host "Creating backup manifest..." -ForegroundColor Yellow
$manifestPath = Join-Path $backupPath "BACKUP_MANIFEST.md"
@"
# RankBrum Hermes Backup Manifest

**Backup Timestamp**: $(Get-Date -Format u)
**Source Workspace**: $WorkspaceRoot
**Backup Location**: $backupPath

## Contents

This backup contains non-sensitive structural and configuration elements
needed to replicate a RankBrum Hermes installation. Sensitive data such as
API keys, credentials, tokens, and user data have been intentionally excluded.

### Included Items
- Blueprint documentation (README, ARCHITECTURE, INSTALLATION, etc.)
- Example configuration files (.env.example, providers.example.yaml)
- Skills structure information (skill names and basic metadata)
- MCP structure information (server names, no tokens)
- Scripts for installation and verification
- Directory structure templates

### Excluded Items (For Security)
- .env files (contain API keys and secrets)
- MCP token files (contain authentication credentials)
- auth.json (contains authentication data)
- Logs (may contain sensitive information)
- Cache directories (may contain temporary sensitive data)
- Session dumps (may contain sensitive request data)
- State databases (may contain sensitive information)
- Memory Core (contains user data and conversations)
- Any other potentially sensitive data

## Restoration Instructions

To use this backup for setting up a new Hermes installation:

1. Install Hermes Agent from official source
2. Copy the contents of this backup to your workspace root
3. Copy .env.example to .env and add your actual API keys
4. Configure your providers in Hermes Settings → Providers
5. Set up your Memory Core directory structure
6. Configure MCP servers (Figma, Hugging Face) in Hermes Settings → MCP
   - You will need to re-authenticate each server
7. Install required RankBrum skills:
   - rankbrum-ceo
   - rankbrum-cto
   - rankbrum-project-manager
   - rankbrum-ui-ux
   - rankbrum-frontend
   - rankbrum-backend
   - rankbrum-qa
   - rankbrum-browser-qa
   - rankbrum-pipeline-analysis
   - rankbrum-pipeline-architecture
   - rankbrum-execution-governance
   - rankbrum-figma-governance
8. Follow the REPLICATION_GUIDE.md for detailed configuration steps

## Security Notice

This backup intentionally excludes all sensitive data.
You MUST provide your own API keys, credentials, and complete MCP authentication
for the system to function properly.
Never share or publish backup files containing actual secrets.
"@ | Out-File -FilePath $manifestPath -Encoding UTF8

Write-Host "  Created backup manifest" -ForegroundColor Green

Write-Host ""
Write-Host "Backup complete!" -ForegroundColor Green
Write-Host "Backup location: $backupPath" -ForegroundColor Green
Write-Host ""
Write-Host "Important Notes:" -ForegroundColor Yellow
Write-Host "- This backup contains ONLY non-sensitive structural elements" -ForegroundColor Yellow
Write-Host("- You must provide your own API keys in .env file" -ForegroundColor Yellow)
Write-Host("- You must re-authenticate MCP servers (Figma, Hugging Face)" -ForegroundColor Yellow)
Write-Host("- You must install required RankBrum skills" -ForegroundColor Yellow)
Write-Host("- You must set up your Memory Core directory structure" -ForegroundColor Yellow)
Write-Host("- Never commit actual secrets to version control" -ForegroundColor Yellow)