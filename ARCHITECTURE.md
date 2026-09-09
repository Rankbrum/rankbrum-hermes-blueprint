# Hermes Architecture Documentation

## System Overview

This document describes the architecture of the RankBrum AI Hermes installation as audited from the current system.

## Core Directories

Based on the audit, the Hermes installation uses the following key directories:

- `/c/Users/renan/AppData/Local/hermes/` - Main installation root
- `/c/Users/renan/AppData/Local/hermes/skills/` - Agent skills and capabilities
- `/c/Users/renan/AppData/Local/hermes/memories/` - Memory storage (USER.md, MEMORY.md)
- `/c/Users/renan/AppData/Local/hermes/mcp-tokens/` - MCP authentication tokens
- `/c/Users/renan/AppData/Local/hermes/sessions/` - Session history and request dumps
- `/c/Users/renan/AppData/Local/hermes/logs/` - System logs
- `/c/Users/renan/AppData/Local/hermes/bin/` - Executables
- `/c/Users/renan/AppData/Local/hermes/cache/` - Various caches
- `/c/Users/renan/.rankbrum/` - Pipeline state and checkpoints

## Agent Hierarchy

The system follows a strict hierarchy:

```
FOUNDER (Human User)
→ CEO_AGENT (Orchestrator)
→ PROJECT_MANAGER_AGENT
→ CTO_AGENT (Orchestrator)
→ SPECIALIST AGENTS (Leaf)
→ INDEPENDENT QA_AGENT
```

## Key Configuration Files

### config.yaml
The main configuration file located at `/c/Users/renan/AppData/Local/hermes/config.yaml` contains:

- **Model Configuration**: Default provider is NVIDIA with fallback providers including OpenRouter, Minimax, Alibaba
- **Database Settings**: WAL journal mode
- **Agent Settings**: Max turns 150, verbose false, reasoning effort medium
- **Terminal Settings**: Local backend, 180s timeout
- **Web Settings**: EXA provider (free tier)
- **Browser Settings**: Local cloud provider, 120s inactivity timeout
- **Memory Settings**: Enabled with 2200 char limit for memory, 1375 for user profile
- **Delegation Settings**: Max 30 iterations, 3 concurrent children, max spawn depth 2
- **MCP Servers**: Figma and Hugging Face configured with OAuth
- **Platform Toolsets**: Defined for CLI, Telegram, Discord, WhatsApp, Slack, Signal, Home Assistant, QQBot, Yuanbao, Teams, Google Chat

### .env
Contains API keys and credentials (not copied for security reasons - see .env.example)

## Skills System

Skills are stored in `/c/Users/renan/AppData/Local/hermes/skills/` organized by category:

### RankBrum Specific Skills
- `rankbrum-ceo` - CEO agent orchestrator
- `rankbrum-cto` - CTO agent orchestrator
- `rankbrum-project-manager` - Creates PROJECT_BRIEF and TECHNICAL_REQUEST
- `rankbrum-ui-ux` - UI/UX specialist
- `rankbrum-frontend` - Frontend specialist
- `rankbrum-backend` - Backend specialist
- `rankbrum-qa` - QA specialist
- `rankbrum-browser-qa` - Combined dogfood, Playwright, and CDP-based browser QA
- `rankbrum-pipeline-analysis` - Analyze founder landing page requests
- `rankbrum-pipeline-architecture` - Pipeline orchestration state machine
- `rankbrum-execution-governance` - State reconciliation
- `rankbrum-figma-governance` - Figma MCP access policy

### Standard Skills Categories
- `autonomous-ai-agents` - For spawning and orchestrating autonomous AI coding agents
- `creative` - Creative content generation
- `email` - Email management
- `github` - GitHub workflow
- `media` - Media content processing
- `mlops` - Machine Learning Operations
- `note-taking` - Obsidian integration
- `openclaw-imports` - Various imports
- `productivity` - Productivity tools
- `rankbrum` - RankBrum specific skills
- `research` - Academic research
- `smart-home` - Smart home device control
- `software-development` - Software development tools

## MCP Servers

Configured MCP servers:
1. **Figma** - URL: https://mcp.figma.com/mcp, Auth: OAuth, Enabled: true
2. **Hugging Face** - URL: https://huggingface.co/mcp, Auth: OAuth, Enabled: true

Figma has specific tool exclusions for security:
- create_new_file
- create_shader
- update_shader
- create_generative_plugin
- update_generative_plugin
- export_video

## Memory System

The system references a Memory Core at `C:\RankBrum\MemoryCore` with:
- `/00_SYSTEM/` - System files
- `/01_CONVERSATIONS/` - Conversation storage
- `/02_PROJECTS/` - Project data
- `/03_DECISIONS/` - Decision records
- `/04_KNOWLEDGE/` - Knowledge base
- `/05_AGENTS/` - Agent configurations
- `/06_PROMPTS/` - Prompt storage
- `/07_LEARNINGS/` - Learning data
- `/08_RAW/` - Raw data
- `/09_DATABASE/` - Database files
- `/10_INBOX/` - Inbox
- `/11_ARCHIVE/` - Archive

Memory is configured in config.yaml with:
- memory_enabled: true
- user_profile_enabled: true
- memory_char_limit: 2200
- user_char_limit: 1375
- nudge_interval: 10

## Governance Principles

Key governance rules identified:

1. **DELEGATE_BEFORE_EXECUTE** - Complex tasks must be delegated before execution
2. **FOUNDER_AUTHORITY_ABSOLUTE** - Founder has ultimate authority over all decisions
3. **CTO_ORCHESTRATOR_ONLY** - CTO acts only as orchestrator, not executor
4. **PROJECT_MANAGER_TECHNICAL_EXECUTION_FORBIDDEN** - PM cannot execute technical work
5. **INDEPENDENT_QA_REQUIRED** - Independent QA approval required before delivery
6. **CONTEXT_INTEGRITY** - Agents must use only current project context
7. **PENDENTE_DE_VALIDACAO** - Unknown information must be marked as pending validation
8. **OPTIONAL_RECOMMENDATION** - Useful ideas not requested must be marked separately
9. **CREDENTIALS_PROTECTION** - Never expose API keys, tokens, or secrets
10. **FOUNDER_AUTHORIZATION_REQUIRED** - Deploy, external actions, spend, etc. require explicit Founder approval

## Quality Assurance

QA processes require:
- Independent verification (QA cannot self-approve)
- Browser-based evidence collection (not just HTTP status checks)
- Navigation, interactivity, focus states, and responsiveness testing
- Evidence collection before approval
- Re-verification after corrections

## Security Measures

- MCP tokens stored securely and not accessible directly
- Config.yaml protected from direct modification by agent tools
- Tool restrictions based on agent roles
- Profile isolation for different access levels (Figma example)
- Environment variables for sensitive data
- No committing of secrets to version control

## Extensions and Plugins

Currently enabled plugin: `orca-status`

Available built-in toolsets vary by platform (CLI, Telegram, etc.) and include:
- browser, clarify, code_execution, computer_use, cronjob, delegation, file, image_gen, memory, session_search, skills, terminal, todo, tts, vision, web
- Platform-specific additions like discord, homeassistant, spotify, etc.

## Version Information

From config.yaml: `_config_version: 39`

## Recovery and State Management

The system implements:
- Pipeline state checkpoints in `/c/Users/renan/.rankbrum/`
- Historical snapshots with millisecond precision
- Recovery decision engines for failure handling
- Checkpoint-based resumption procedures
- Anti-duplication controls to prevent re-execution of completed work

## References

For detailed information on specific components, see:
- Individual agent skill documentation in `docs/agents/`
- Configuration examples in `configs/`
- Skill documentation in `skills/`
- MCP governance in `mcp/`
- Governance details in `rankbrum-execution-governance` and `rankbrum-figma-governance` skills