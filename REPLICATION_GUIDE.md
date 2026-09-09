# RankBrum Hermes Blueprint Replication Guide

This guide explains how to replicate your RankBrum Hermes installation from one computer to another using this blueprint repository.

## Overview

The replication process involves:
1. Preserving your current Hermes configuration on Computer A
2. Creating the blueprint repository (already done)
3. Pushing the blueprint to GitHub (private repository)
4. Setting up a new Hermes installation on Computer B/VPS
5. Applying the blueprint to configure the new installation
6. Verifying the replication was successful

## Phase 1: Preparation on Computer A

### 1.1 Audit Your Current Installation
Before starting, ensure you have documented your current Hermes installation:
- Review the ARCHITECTURE.md in this blueprint
- Verify all agents, skills, MCPs, and configurations are documented
- Note any customizations you've made

### 1.2 Prepare for Blueprint Creation
Ensure you have:
- Access to your Hermes installation at `C:\Users\[youruser]\AppData\Local\hermes\`
- Permission to read configuration files (but not extract secrets)
- The rankbrum-hermes-blueprint directory created as shown in previous steps

### 1.3 Verify No Secrets Are Included
Double-check that:
- No `.env` files were copied
- No MCP token files were extracted
- No API keys or credentials appear in any documentation
- All placeholders are used instead of real values

## Phase 2: GitHub Setup

### 2.1 Create Private Repository
If GitHub CLI is installed and authenticated:
```bash
# From within the rankbrum-hermes-blueprint directory
git init
git add .
git commit -m "docs: initialize RankBrum Hermes Blueprint"

# Create private repository
gh repo create rankbrum-hermes-blueprint --private --source=. --push
```

If GitHub CLI is not available:
1. Go to GitHub.com and create a new private repository named `rankbrum-hermes-blueprint`
2. Do NOT initialize with README, .gitignore, or license
3. Push your local repository:
```bash
git remote add origin https://github.com/[yourusername]/rankbrum-hermes-blueprint.git
git branch -M main
git push -u origin main
```

### 2.2 Verify Repository
Confirm your repository contains:
- All documentation files
- Directory structure as planned
- No sensitive data
- Proper .gitignore (to be created next)

## Phase 3: Setup on Computer B/VPS

### 3.1 Install Hermes Agent
Follow the instructions in INSTALLATION.md to install Hermes on your new system:
1. Download and run the Hermes installer
2. Complete basic setup
3. Verify the installation works

### 3.2 Clone the Blueprint Repository
On your new computer:
```bash
# Clone the private repository (you'll need to authenticate)
git clone https://github.com/[yourusername]/rankbrum-hermes-blueprint.git
cd rankbrum-hermes-blueprint
```

### 3.3 Apply the Blueprint

#### 3.3.1 Configure Model Providers
Refer to ARCHITECTURE.md for the provider configuration:
1. Open Hermes Settings → Providers
2. Configure your preferred providers (NVIDIA, OpenRouter, etc.)
3. Add API keys (these go in your .env file, NOT in the blueprint)
4. Set up fallback chains as documented:
   - Default: nvidia/nemotron-3-ultra-550b-a55b (NVIDIA provider)
   - Fallback 1: minimax/minimax-m3:free (OpenRouter)
   - Fallback 2: nvidia/nemotron-3-super-120b-a12b:free (OpenRouter)
   - And others as listed in config.yaml

#### 3.3.2 Configure Memory Core
1. Decide on your Memory Core location (e.g., C:\RankBrum\MemoryCore)
2. Create the directory structure:
```
C:\RankBrum\MemoryCore\
├── 00_SYSTEM\
├── 01_CONVERSATIONS\
├── 02_PROJECTS\
├── 03_DECISIONS\
├── 04_KNOWLEDGE\
├── 05_AGENTS\
├── 06_PROMPTS\
├── 07_LEARNINGS\
├── 08_RAW\
├── 09_DATABASE\
├── 10_INBOX\
└── 11_ARCHIVE\
```
3. In Hermes Settings → Memory:
   - Enable memory features
   - Set memory_char_limit to 2200
   - Set user_char_limit to 1375
   - Configure the Memory Root path

#### 3.3.3 Install Required Skills
Based on the audit, install these RankBrum skills:
1. rankbrum-ceo
2. rankbrum-cto
3. rankbrum-project-manager
4. rankbrum-ui-ux
5. rankbrum-frontend
6. rankbrum-backend
7. rankbrum-qa
8. rankbrum-browser-qa
9. rankbrum-pipeline-analysis
10. rankbrum-pipeline-architecture
11. rankbrum-execution-governance
12. rankbrum-figma-governance

Plus any standard skills you used:
- autonomous-ai-agents (for Claude Code, Codex, etc.)
- creative
- email
- github
- media
- mlops
- note-taking
- productivity
- research
- smart-home
- software-development

#### 3.3.4 Configure MCP Servers
Set up the MCP servers as documented:

**Figma MCP:**
1. URL: https://mcp.figma.com/mcp
2. Auth: OAuth
3. Enabled: true
4. Tools exclusion (for security):
   - create_new_file
   - create_shader
   - update_shader
   - create_generative_plugin
   - update_generative_plugin
   - export_video
5. Complete OAuth authentication

**Hugging Face MCP:**
1. URL: https://huggingface.co/mcp
2. Auth: OAuth
3. Enabled: true
4. Complete OAuth authentication

#### 3.3.5 Configure Platform Toolsets
Ensure the following toolsets are available for your intended platforms:
- CLI: browser, clarify, code_execution, computer_use, cronjob, delegation, file, image_gen, memory, session_search, skills, terminal, todo, tts, vision, web
- Telegram: same as CLI plus telegram-specific tools
- Discord: discord, discord_admin
- WhatsApp: hermes-whatsapp
- Slack: hermes-slack
- etc.

Refer to the platform_toolsets section in config.yaml for exact configurations.

#### 3.3.6 Apply Governance Settings
Configure these governance principles in your Hermes setup:
- DELEGATE_BEFORE_EXECUTE: Ensure complex tasks are delegated
- FOUNDER_AUTHORITY_ABSOLUTE: Remember you (the Founder) have final authority
- CTO_ORCHESTRATOR_ONLY: CTO agents should only orchestrate, not execute
- PROJECT_MANAGER_TECHNICAL_EXECUTION_FORBIDDEN: PMs don't do technical work
- INDEPENDENT_QA_REQUIRED: Require QA approval before considering work complete
- CONTEXT_INTEGRITY: Agents use only current project context
- PENDENTE_DE_VALIDACAO: Mark unknown information appropriately
- OPTIONAL_RECOMMENDATION: Separate useful ideas from requirements
- Credentials protection: Never expose secrets in agent contexts
- Founder authorization required for: deploy, external actions, spending, etc.

## Phase 4: Verification

### 4.1 Run Verification Checks
Use the verification checklist from the blueprint:
- [ ] Dependencies documented and installed
- [ ] Providers documented and configured
- [ ] Agents documented and skills installed
- [ ] MCPs documented and configured
- [ ] Skills documented and installed
- [ ] Necessary prompts preserved
- [ ] Secrets removed (verified no actual credentials in blueprint)
- [ ] Scripts created and validated
- [ ] Memory Core properly configured and decoupled
- [ ] Installation guide complete
- [ ] Replication guide complete

### 4.2 Test Basic Functionality
Test that your new installation can:
1. Respond to basic queries
2. Load and use skills correctly
3. Delegate tasks between agents following the hierarchy
4. Access MCP servers (test with simple read operations)
5. Use memory functions
6. Follow governance principles

### 4.3 Test a Simple Workflow
Try a simple RankBrum-style workflow:
1. Founder request: "Create a simple landing page for my consulting service"
2. Observe delegation: Founder → CEO → PM → CTO → Specialists → QA
3. Verify each agent follows their documented responsibilities
4. Check that QA requires evidence before approval
5. Confirm no external actions occur without explicit authorization

## Phase 5: Ongoing Maintenance

### 5.1 Keeping Blueprint Updated
As you modify your Hermes installation:
1. Document changes in the appropriate blueprint sections
2. Update version numbers in CHANGELOG.md
3. Commit changes to your local repository
4. Push to GitHub regularly

### 5.2 Security Best Practices
- Never commit .env files or MCP tokens
- Regularly audit your installation for accidental secret inclusion
- Use the verification scripts to check for potential leaks
- Rotate API keys periodically
- Review MCP permissions regularly

### 5.3 Backup Strategy
- Regularly backup your Memory Core directory
- Export critical configurations (without secrets)
- Document any custom skills or modifications
- Keep your blueprint repository updated

## Troubleshooting

### Common Issues and Solutions

**Issue: Skills not loading properly**
- Solution: Check skill compatibility with your Hermes version
- Solution: Verify sufficient disk space and memory
- Solution: Review Hermes logs for skill-specific errors

**Issue: MCP connections failing**
- Solution: Verify OAuth credentials are valid and not expired
- Solution: Check network connectivity to MCP endpoints
- Solution: Try re-authenticating in Hermes Settings → MCP
- Solution: Verify MCP server status

**Issue: Agent hierarchy not followed**
- Solution: Review agent skill documentation
- Solution: Check delegation contexts are properly formed
- Solution: Verify agents have correct reporting_to relationships

**Issue: Governance principles being violated**
- Solution: Review the rankbrum-execution-governance and rankbrum-figma-governance skills
- Solution: Ensure Founder authorization is obtained for restricted actions
- Solution: Check that QA independence is maintained

**Issue: Memory Core not functioning**
- Solution: Verify directory structure is correct
- Solution: Check permissions on Memory Core directories
- Solution: Verify memory settings in Hermes configuration
- Solution: Check for error messages in logs related to memory

## Conclusion

By following this guide, you should be able to successfully replicate your RankBrum Hermes installation to a new computer or VPS. Remember that the blueprint provides the structure and configuration patterns, but you must supply your own credentials and API keys for the system to function fully.

Always prioritize security by never committing secrets to version control, and follow the governance principles that make the RankBrum system reliable and trustworthy.