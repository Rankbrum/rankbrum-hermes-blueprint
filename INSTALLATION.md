# Hermes Installation Guide

This document provides instructions for installing Hermes Agent as the foundation for a RankBrum AI system.

## Prerequisites

Before installing Hermes, ensure your system meets these requirements:

### Operating System
- Windows 10 or 11 (64-bit)
- Linux (Ubuntu 20.04+, CentOS 7+, or similar)
- macOS 10.15+

### Hardware Requirements
- Minimum 4GB RAM (8GB+ recommended)
- Minimum 2 CPU cores (4+ recommended)
- Minimum 10GB free disk space
- Internet connectivity for model providers and updates

### Software Dependencies
- Git (for version control)
- Python 3.11+ (for some skills and extensions)
- Node.js 16+ (for certain MCP servers and tools)
- Web browser (Chrome, Firefox, Edge, or Safari)

## Installation Steps

### 1. Download Hermes Agent

Visit the official Hermes Agent website or use the provided installer:
- Download from: https://hermes-agent.nousresearch.com/
- Or use the official Hermes setup executable

### 2. Run the Installer

Execute the downloaded installer and follow the prompts:
- Accept the license agreement
- Choose installation directory (default: C:\Users\[youruser]\AppData\Local\hermes\ on Windows)
- Select components to install (core agent recommended)
- Complete the installation process

### 3. Initial Configuration

After installation, Hermes will launch for initial setup:
- Choose your preferred interface language
- Configure basic appearance settings
- Set up initial model provider (if prompted)

### 4. Verify Installation

Open Hermes and verify:
- The agent responds to basic queries
- System status shows as healthy
- No critical errors in the logs

## Post-Installation Configuration

### Basic Configuration

1. **Model Providers**: Configure your preferred LLM providers in Settings → Providers
   - Add API keys for OpenRouter, NVIDIA, Minimax, or other providers
   - Set up fallback chains as needed

2. **Memory Configuration**: 
   - Enable memory features in Settings → Memory
   - Set memory limits according to your needs
   - Configure Memory Core path if using external storage

3. **MCP Servers**:
   - Configure Figma MCP: Settings → MCP → Figma
   - Configure Hugging Face MCP: Settings → MCP → Hugging Face
   - Complete OAuth authentication for each

4. **Skills Installation**:
   - Browse available skills in Settings → Skills
   - Install required RankBrum skills:
     * rankbrum-ceo
     * rankbrum-cto
     * rankbrum-project-manager
     * rankbrum-ui-ux
     * rankbrum-frontend
     * rankbrum-backend
     * rankbrum-qa
     * rankbrum-browser-qa
     * rankbrum-pipeline-analysis
     * rankbrum-pipeline-architecture
     * rankbrum-execution-governance
     * rankbrum-figma-governance
   - Install any additional skills needed for your use case

### Advanced Configuration

1. **Security Settings**:
   - Review agent permissions in Settings → Security
   - Configure tool restrictions for different agent roles
   - Set up approval workflows for sensitive operations

2. **Performance Optimization**:
   - Adjust context window sizes in Settings → Performance
   - Configure caching preferences
   - Set up token monitoring if needed

3. **Integrations**:
   - Configure email, GitHub, or other platform integrations
   - Set up webhook endpoints if needed
   - Configure notification preferences

## Directory Structure After Installation

After installation, your Hermes directory will contain:
```
hermes-root/
├── bin/                    # Executables
├── cache/                  # Various caches
├ ├── delegation/          # Delegation transcripts
├ ├── model_catalog.json   # Model provider information
├ └── ...                  # Other cache files
├ ├── ...                  # Other files and directories
├ ├── cron/                # Scheduled jobs
├ ├── desktop/             # Desktop-specific files
├ ├── mcp-tokens/          # MCP authentication tokens (protected)
├ ├── memories/            # Memory storage (USER.md, MEMORY.md)
├ ├── skills/              # Agent skills and capabilities
├ ├── sessions/            # Session history
├ ├── logs/                # System and application logs
├ ├── state/               # Application state databases
├ └── config.yaml          # Main configuration file
```

## First Run Verification

After installation and configuration, verify:
1. Hermes launches successfully
2. Basic chat functionality works
3. Skills load correctly
4. MCP connections authenticate properly
5. Memory system functions as expected
6. No error messages in the logs

## Troubleshooting Common Issues

### Installation Fails
- Ensure you have administrator/root privileges
- Check antivirus isn't blocking the installer
- Verify sufficient disk space
- Try running installer as administrator

### Agent Doesn't Respond
- Check internet connectivity
- Verify API keys are configured correctly
- Review logs for error messages
- Try restarting the Hermes application

### MCP Connection Issues
- Verify OAuth credentials are valid
- Check network connectivity to MCP endpoints
- Ensure required ports are open
- Try re-authenticating in Settings → MCP

### Skill Loading Problems
- Check skill compatibility with your Hermes version
- Verify sufficient memory/storage
- Review skill-specific logs
- Try reinstalling problematic skills

## Next Steps

After successful installation:
1. Review the REPLICATION_GUIDE.md for configuring your RankBrum-specific setup
2. Set up your Memory Core at C:\RankBrum\MemoryCore (or alternative location)
3. Configure agent roles and delegation patterns per ARCHITECTURE.md
4. Test basic delegation workflows
5. Begin building your first RankBrum AI project

## Support

For additional help:
- Consult the official Hermes documentation: https://hermes-agent.nousresearch.com/docs/
- Review the RankBrum-specific documentation in this repository
- Check the Hermes community forums
- Review log files in the logs/ directory for diagnostic information