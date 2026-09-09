# Troubleshooting Guide

This guide provides solutions to common issues encountered when setting up or using the RankBrum Hermes system.

## Installation Issues

### Problem: Hermes fails to start or crashes on launch
**Solutions:**
1. Check system requirements - ensure minimum 4GB RAM and adequate disk space
2. Verify graphics drivers are up to date (important for GPU-accelerated inference)
3. Check Windows Event Viewer for application errors
4. Try running as administrator
5. Temporarily disable antivirus software to see if it's blocking execution
6. Check logs in `C:\Users\[youruser]\AppData\Local\hermes\logs\` for specific error messages

### Problem: Installation hangs or fails during setup
**Solutions:**
1. Ensure you have administrator privileges
2. Check internet connectivity - installer may need to download components
3. Verify sufficient free disk space (minimum 10GB recommended)
4. Try downloading the installer again - may have been corrupted
5. Run installer in compatibility mode if using older Windows version
6. Check for conflicting software that might interfere with installation

### Problem: "Access denied" errors during installation
**Solutions:**
1. Run installer as administrator (right-click → "Run as administrator")
2. Check folder permissions on the installation directory
3. Ensure no other Hermes instances are running
4. Temporarily disable UAC if necessary (not recommended for permanent use)
5. Install to a different directory with full user permissions

## Configuration Issues

### Problem: Model providers not responding or returning errors
**Solutions:**
1. Verify API keys are correctly entered in Settings → Providers
2. Check if provider service is experiencing downtime (check provider status pages)
3. Verify you have sufficient credits/quota with the provider
4. Try alternative providers as fallbacks
5. Check network connectivity and firewall settings
6. Verify model names are correctly spelled in configuration
7. Check rate limiting - wait and try again if hitting provider limits

### Problem: MCP connections failing to authenticate
**Solutions:**
1. Verify OAuth credentials are valid and not expired
2. Try re-authenticating: Settings → MCP → [Server] → Reconnect
3. Check network connectivity to MCP endpoints (figma.com, huggingface.co)
4. Verify ports 443 (HTTPS) are not blocked by firewall
5. Try clearing MCP cache and restarting Hermes
6. Check if MCP service requires specific IP whitelisting
7. Verify system date/time is correct (important for OAuth)

### Problem: Skills failing to load or showing errors
**Solutions:**
1. Verify skill compatibility with your Hermes version
2. Check available disk space - skills may need storage for data
3. Review skill-specific logs in `C:\Users\[youruser]\AppData\Local\hermes\logs\`
4. Try reinstalling the problematic skill
5. Check if skill has dependencies on other skills that aren't installed
6. Verify sufficient memory allocation for complex skills
7. Check skill documentation for special installation requirements

## Agent and Delegation Issues

### Problem: Agents not following proper hierarchy or delegation patterns
**Solutions:**
1. Review agent skill documentation for correct reporting_to relationships
2. Check delegation contexts are properly formed with all required information
3. Verify agents have been granted appropriate toolsets for their roles
4. Check for conflicting skills that might override agent behavior
5. Ensure CONTEXT_INTEGRITY principle is being followed
6. Review delegation limits (max_concurrent_children, max_spawn_depth)
7. Check if agents are stuck in ANALYSIS_ONLY mode when CONTROLLED_EXECUTION is needed

### Problem: Delegation not returning results or timing out
**Solutions:**
1. Check delegation logs in `C:\Users\[youruser]\AppData\Local\hermes\cache\delegation\`
2. Verify subagents have sufficient time to complete complex tasks
3. Check if subagents are waiting for missing context or information
4. Verify delegation chains aren't creating circular dependencies
5. Check for resource exhaustion (memory, CPU) preventing subagent completion
6. Review max_iterations setting in config.yaml
7. Check if subagents are hitting tool limits or approval requirements

## Quality Assurance Issues

### Problem: QA rejecting work that appears correct
**Solutions:**
1. Verify QA is collecting browser-based evidence, not just HTTP status
2. Check if QA is testing navigation, interactivity, focus states, and responsiveness
3. Ensure QA has access to the implemented work for testing
4. Verify QA independence - they should be a different agent instance
5. Check if acceptance criteria are clearly defined and testable
6. Verify QA is not confusing technical implementation with visual design
7. Check if environment differences are causing false negatives (localhost vs deployed)

### Problem: QA approving work without proper evidence
**Solutions:**
1. Remind QA of EVIDENCE_BEFORE_APPROVAL principle
2. Check if QA is confusing static analysis with actual browser testing
3. Verify QA is using the proper tools (Playwright primary, Dogfood exploratory)
4. Ensure QA is testing the actual deployed/running implementation
5. Check if QA is following the mandatory web QA checklist
6. Verify QA is not approving based on intent rather than actual results
7. Review QA governance settings in the rankbrum-qa skill

## Memory System Issues

### Problem: Memory not persisting between sessions
**Solutions:**
1. Verify memory_enabled is set to true in config.yaml
2. Check memory_char_limit and user_char_limit settings
3. Verify Memory Core directory structure is correct
4. Check folder permissions on Memory Core directories
5. Look for error messages in logs related to memory operations
6. Verify nudge_interval setting is appropriate
7. Check if memory is being explicitly cleared or reset somewhere

### Problem: Memory Core growing too large or slowing performance
**Solutions:**
1. Review what types of data are being stored in memory
2. Check if sensitive information is being inadvertently stored
3. Consider implementing memory pruning or archiving strategies
4. Verify compression settings are working properly
5. Check if old conversations or projects need to be cleaned up
6. Review memory usage patterns and adjust limits accordingly
7. Consider implementing memory categorization or tagging

## Governance and Security Issues

### Problem: Unauthorized external actions occurring
**Solutions:**
1. Verify FOUNDER_AUTHORITY_ABSOLUTE principle is understood
2. Check that deploy_allowed and external_actions_allowed are false by default
3. Ensure Founder authorization is obtained for restricted actions
4. Review agent toolsets to ensure they don't have unnecessary capabilities
5. Check for skill or configuration issues that might bypass restrictions
6. Verify approval workflows are functioning correctly
7. Monitor logs for any unauthorized external action attempts

### Problem: Potential secret leakage in logs or outputs
**Solutions:**
1. Regularly review logs for accidental API key or token inclusion
2. Check agent contexts to ensure credentials aren't being passed
3. Verify .env files are properly protected and not committed to version control
4. Check MCP token files are not accessible to unauthorized processes
5. Review skill implementations for proper secret handling
6. Consider implementing automated secret scanning in development workflows
7. Immediately rotate any credentials that may have been exposed

## Performance Issues

### Problem: Slow response times or laggy interactions
**Solutions:**
1. Check system resource usage (CPU, memory, disk I/O)
2. Verify model provider performance and latency
3. Check if context window is too large causing processing delays
4. Review caching settings and effectiveness
5. Check for background processes consuming resources
6. Verify network connectivity to external services
7. Consider reducing concurrent operations if system is overloaded

### Problem: High memory consumption over time
**Solutions:**
1. Check for memory leaks in long-running processes
2. Verify memory pruning and compression settings are working
3. Check if conversations or sessions are not being properly cleaned up
4. Review tool usage patterns that might retain large amounts of data
5. Check if caching is retaining too much data indefinitely
6. Verify background processes are properly terminating
7. Consider implementing session timeout or cleanup policies

## Recovery and State Issues

### Problem: Unable to resume from checkpoint or save state
**Solutions:**
1. Verify `.rankbrum` directory exists and is accessible
2. Check folder permissions on checkpoint and state directories
3. Look for error messages in logs related to checkpoint operations
4. Verify sufficient disk space for state files
5. Check if state files are becoming corrupted
6. Verify system clock is correct (timestamps are important for state)
7. Try clearing old checkpoints if they're causing conflicts

### Problem: Recovery engine not functioning properly after failures
**Solutions:**
1. Verify recovery decision engine skill is properly installed
2. Check if recovery tests are passing (run verification scripts)
3. Verify checkpoint integrity before relying on recovery
4. Check if failure scenarios are within the recovery engine's scope
5. Verify anti-duplication controls are working properly
6. Check if recovery is being blocked by governance restrictions
7. Review recovery logs for specific error indications

## Specific Error Message Solutions

### Error: "Refusing to write to Hermes config file"
**Solution:** Use `hermes config set` command instead of direct file modification. Agent tools are blocked from modifying config.yaml for security.

### Error: MCP token files access denied
**Solution:** These are protected by design. Use Hermes MCP tools instead of direct file access. Never attempt to bypass this protection.

### Error: Agent hit max iterations without completion
**Solution:** Increase max_iterations in config.yaml if appropriate, or check if the task is genuinely stuck and needs human intervention.

### Error: QA status BLOCKED - insufficient information
**Solution:** Provide more context or check if the work to be tested is actually available and accessible.

### Error: Delegation failed - child agent timed out
**Solution:** Check if subtask is overly complex, verify subagent has needed tools and context, consider breaking task into smaller pieces.

## Verification Procedures

### Basic System Verification
1. [ ] Hermes launches without errors
2. [ ] Basic chat functionality works
3. [ ] Skills load and are accessible
4. [ ] MCP connections authenticate successfully
5. [ ] Memory system functions (can store and recall information)
6. [ ] Agent hierarchy follows documented patterns
7. [ ] Governance principles are observable in behavior

### Advanced Functionality Verification
1. [ ] Complex task delegation works correctly
2. [ ] QA requires evidence before approval
3. [ ] Founder authorization is required for restricted actions
4. [ ] Context integrity is maintained between agents
5. [ ] Recovery systems work after simulated failures
6. [ ] Memory persists correctly between sessions
7. [ ] Logging captures appropriate diagnostic information

### Security Verification
1. [ ] No API keys or secrets appear in logs or outputs
2. [ ] Config.yaml cannot be modified by agent tools
3. [ ] MCP tokens are not accessible directly
4. [ ] Tool restrictions are enforced per agent role
5. [ ] Approval workflows function for restricted actions
6. [ ] Audit trails are present for security-relevant events
7. [ ] Data protection measures are functioning

## When to Seek Additional Help

Contact support or consult documentation if:
1. Issues persist after trying all suggested solutions
2. You encounter error messages not covered in this guide
3. System instability affects core functionality
4. Security concerns arise that you cannot resolve
5. Performance degradation significantly impacts usability
6. You need clarification on governance principles or procedures
7. You suspect data corruption or loss

## Getting Help Effectively

When seeking assistance, be prepared to provide:
1. Exact error messages and when they occur
2. Relevant log file excerpts (with secrets removed)
3. System specifications and Hermes version
4. Steps to reproduce the issue
5. What you've already tried to resolve it
6. Any relevant configuration details (without secrets)
7. Timestamps or session IDs if available

Remember to always remove or obscure any sensitive information before sharing logs or configuration details with others.