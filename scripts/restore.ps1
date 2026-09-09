# RankBrum Hermes Blueprint Restore Script
# This script restores allowed configurations from backup

<#
.SYNOPSIS
    Restores allowed Hermes configurations from RankBrum AI blueprint backup

.DESCRIPTION
    This script restores allowed Hermes configurations that were previously backed up
    using the backup.ps1 script. It helps replicate the structural and configuration
    elements of a RankBrum Hermes installation to a new system.

.PARAMETER BackupPath
    The path to the backup directory to restore from

.PARAMETER WorkspaceRoot
    The root directory for the Hermes installation (default: $env:LOCALAPPDATA\hermes)

.EXAMPLE
    .\restore.ps1 -BackupPath "./backup/hermes_backup_20260908_143022" -WorkspaceRoot "C:\hermes"

.NOTES
    This script only restores non-sensitive configuration files and directories.
    It does not restore:
    - .env files (you must create these with your actual API keys)
    - MCP token files (you must re-authenticate each server)
    - auth.json (you must re-authenticate)
    - Logs (these are generated fresh)
    - Cache directories (these are generated fresh)
    - Session dumps (these are generated fresh)
    - State databases (these are initialized fresh)
    - Memory Core (you must set up your own)
    
    After running this script, you must:
    1. Install Hermes Agent if not already installed
    2. Create .env.example -> .env with your actual API keys
    3. Configure providers in Hermes Settings → Providers
    4. Set up your Memory Core directory structure
    5. Configure and authenticate MCP servers (Figma, Hugging Face)
    6. Install required RankBrum skills
    7. Follow the REPLICATION_GUIDE.md for detailed configuration steps
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$BackupPath,
    
    [Parameter(Mandatory=$false)]
    [string]$WorkspaceRoot = "$env:LOCALAPPDATA\hermes"
)

Write-Host "RankBrum Hermes Blueprint Restore" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Validate paths
if (-not (Test-Path $BackupPath)) {
    Write-Error "Backup path '$BackupPath' does not exist."
    exit 1
}

if (-not (Test-Path (Join-Path $BackupPath "BACKUP_MANIFEST.md"))) {
    Write-Error "Invalid backup directory: BACKUP_MANIFEST.md not found in '$BackupPath'"
    exit 1
}

# Read manifest for information
$manifest = Get-Content (Join-Path $BackupPath "BACKUP_MANIFEST.md") -Raw
Write-Host "Restoring from backup:" -ForegroundColor Yellow
Write-Host $manifest.Substring($manifest.IndexOf("**Backup Timestamp**"), 200)
Write-Host ""

# Validate workspace root
if (-not (Test-Path $WorkspaceRoot)) {
    Write-Warning "Workspace root '$WorkspaceRoot' does not exist. Creating it..."
    New-Item -ItemType Directory -Path $WorkspaceRoot -Force | Out-Null
}

# Define what to restore (non-sensitive files and directories from backup)
$itemsToRestore = @(
    # Configuration examples
    @{ Source = "configs/config.yaml.example"; Dest = "config.yaml.example" },
    @{ Source = "configs/providers.example.yaml"; Dest = "configs/providers.example.yaml" },
    
    # Documentation
    @{ Source = "README.md"; Dest = "README.md" },
    @{ Source = "ARCHITECTURE.md"; Dest = "ARCHITECTURE.md" },
    @{ Source = "INSTALLATION.md"; Dest = "INSTALLATION.md" },
    @{ Source = "REPLICATION_GUIDE.md"; Dest = "REPLICATION_GUIDE.md" },
    @{ Source = "TROUBLESHOOTING.md"; Dest = "TROUBLESHOOTING.md" },
    @{ Source = "CHANGELOG.md"; Dest = "CHANGELOG.md" },
    
    # Scripts
    @{ Source = "scripts/"; Dest = "scripts/" },
    
    # Docs
    @{ Source = "docs/"; Dest = "docs/" }
)

# Restore items
Write-Host "Restoring non-sensitive configuration and documentation..." -ForegroundColor Yellow
foreach ($item in $itemsToRestore) {
    $sourcePath = Join-Path $BackupPath $item.Source
    $destPath = Join-Path $WorkspaceRoot $item.Dest
    
    if (Test-Path $sourcePath) {
        # Ensure destination directory exists
        $destDir = Split-Path $destPath -Parent
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        
        if (Test-Path $sourcePath -PathType Container) {
            # Copy directory
            Copy-Item -Path $sourcePath -Destination $destDir -Recurse -Force
            Write-Host "  Restored directory: $($item.Source)" -ForegroundColor Green
        } else {
            # Copy file
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            Write-Host "  Restored file: $($item.Source)" -ForegroundColor Green
        }
    } else {
        Write-Warning "Source not found in backup: $sourcePath"
    }
}

# Restore skills structure info (informational only)
Write-Host ""
Write-Host "Restoring skills structure information..." -ForegroundColor Yellow
$skillsBackupPath = Join-Path $BackupPath "skills_structure"
if (Test-Path $skillsBackupPath) {
    $skillsDestPath = Join-Path $WorkspaceRoot "skills_structure"
    if (-not (Test-Path $skillsDestPath)) {
        New-Item -ItemType Directory -Path $skillsDestPath -Force | Out-Null
    }
    
    Copy-Item -Path $skillsBackupPath -Destination $skillsDestPath -Recurse -Force
    Write-Host "  Restored skills structure information" -ForegroundColor Green
    
    # Show what skills were in the backup
    Get-ChildItem -Path $skillsBackupPath -Filter "*.md" | ForEach-Object {
        $skillName = $_.BaseName
        Write-Host "    - $skillName" -ForegroundColor DarkGray
    }
} else {
    Write-Warning "Skills structure information not found in backup"
}

# Restore MCP structure info (informational only)
Write-Host ""
Write-Host "Restoring MCP structure information..." -ForegroundColor Yellow
$mcpBackupPath = Join-Path $BackupPath "mcp_structure"
if (Test-Path $mcpBackupPath) {
    $mcpDestPath = Join-Path $WorkspaceRoot "mcp_structure"
    if (-not (Test-Path $mcpDestPath)) {
        New-Item -ItemType Directory -Path $mcpDestPath -Force | Out-Null
    }
    
    Copy-Item -Path $mcpBackupPath -Destination $mcpDestPath -Recurse -Force
    Write-Host "  Restored MCP structure information" -ForegroundColor Green
} else {
    Write-Warning "MCP structure information not found in backup"
}

Write-Host ""
Write-Host "Restore complete!" -ForegroundColor Green
Write-Host "Restored to: $WorkspaceRoot" -ForegroundColor Green
Write-Host ""
Write-Host "Important Next Steps:" -ForegroundColor Yellow
Write-Host "1. Install Hermes Agent if not already installed" -ForegroundColor Yellow
Write-Host "2. Copy .env.example to .env and add your actual API keys:" -ForegroundColor Yellow
Write-Host "   copy '$WorkspaceRoot\configs\env.example' '$WorkspaceRoot\.env'" -ForegroundColor Yellow
Write-Host "3. Configure your providers in Hermes Settings → Providers" -ForegroundColor Yellow
Write-Host "4. Set up your Memory Core directory structure (see REPLICATION_GUIDE.md)" -ForegroundColor Yellow
Write-Host "5. Configure and authenticate MCP servers:" -ForegroundColor Yellow
Write-Host "   - Figma MCP: https://mcp.figma.com/mcp (OAuth)" -ForegroundColor Yellow
Write-Host "   - Hugging Face MCP: https://huggingface.co/mcp (OAuth)" -ForegroundColor Yellow
Write-Host "6. Install required RankBrum skills:" -ForegroundColor Yellow
Write-Host "   - rankbrum-ceo" -ForegroundColor Yellow
Write-Host "   - rankbrum-cto" -ForegroundColor Yellow
Write-Host "   - rankbrum-project-manager" -ForegroundColor Yellow
Write-Host "   - rankbrum-ui-ux" -ForegroundColor Yellow
Write-Host "   - rankbrum-frontend" -ForegroundColor Yellow
Write-Host "   - rankbrum-backend" -ForegroundColor Yellow
Write-Host "   - rankbrum-qa" -ForegroundColor Yellow
Write-Host "   - rankbrum-browser-qa" -ForegroundColor Yellow
Write-Host "   - rankbrum-pipeline-analysis" -ForegroundColor Yellow
Write-Host "   - rankbrum-pipeline-architecture" -ForegroundColor Yellow
Write-Host "   - rankbrum-execution-governance" -ForegroundColor Yellow
Write-Host "   - rankbrum-figma-governance" -ForegroundColor Yellow
Write-Host "7. Follow the REPLICATION_GUIDE.md for detailed configuration steps" -ForegroundColor Yellow
Write-Host ""
Write-Host "Security Reminders:" -ForegroundColor Yellow
Write-Host "- Never commit .env files or MCP tokens to version control" -ForegroundColor Yellow
Write-Host("- Replace all placeholder values with your actual API keys" -ForegroundColor Yellow)
Write-Host("- You must re-authenticate MCP servers - tokens are not backed up for security" -ForegroundColor Yellow)
Write-Host("- Follow all governance principles documented in the blueprint" -ForegroundColor Yellow)