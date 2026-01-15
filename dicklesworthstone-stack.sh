#!/usr/bin/env sh
set -eu

# =============================================================================
# Dicklesworthstone Stack Installer/Updater
# =============================================================================
#
# NOTE: This is a wholesale install and update script. It is not intended to be cloned and used straight away without paying attention to the individual components you want to use. Please review the individual `install_all()` and `update_all()` functions and the comments for each component before running. The easiest way of eliminating any given component is to manually comment out items from these two orchestration scripts commands before running them.
#
#
# A curated set of command-line utilities from the Dicklesworthstone "Agent
# Flywheel (ACFS)" software ecosystem for AI-assisted development workflows.
#
# Website:  https://agent-flywheel.com/
# Setup:    https://github.com/Dicklesworthstone/agentic_coding_flywheel_setup
# Author:   https://github.com/Dicklesworthstone
#
# -----------------------------------------------------------------------------
# ASSUMPTIONS
# -----------------------------------------------------------------------------
#   - uv is installed and on PATH
#   - python3 is installed and on PATH
#   - curl is installed and on PATH
#   - bash is recommended (sh fallback works for most installers)
#
# -----------------------------------------------------------------------------
# BEHAVIOR
# -----------------------------------------------------------------------------
#   - Runs installs/updates from the user root directory ($HOME) to avoid
#     accidentally performing project-local actions.
#   - Some tools are installed once per user (global CLI + home-directory
#     config), while others require per-repository setup (hooks, registrations).
#
# -----------------------------------------------------------------------------
# COMPONENTS (in recommended install order)
# -----------------------------------------------------------------------------
#
#   1) NTM - Named Tmux Manager
#      https://github.com/Dicklesworthstone/ntm
#      A tmux-based session manager for running and supervising multiple AI
#      coding agents in parallel. Provides dashboards, activity/health
#      monitoring, output streaming, and tooling to search/extract/diff agent
#      output. Supports "robot mode" commands for scripting and integrations.
#
#   2) SLB - Simultaneous Launch Button
#      https://github.com/Dicklesworthstone/slb
#      A two-person-rule CLI for AI agent workflows that gates potentially
#      destructive commands behind explicit peer review. Classifies commands
#      into risk tiers and tracks approvals in a local SQLite state store.
#
#   3) UBS - Ultimate Bug Scanner
#      https://github.com/Dicklesworthstone/ultimate_bug_scanner
#      A fast, multi-language bug scanner designed to catch common production
#      issues with a single command. Emits CI-friendly output and machine-
#      readable reports for automation.
#
#   4) CASS - Coding Agent Session Search
#      https://github.com/Dicklesworthstone/coding_agent_session_search
#      A unified search/index tool for local coding-agent history across
#      multiple assistants (Claude Code, Codex, Gemini, Cursor, Aider, etc.).
#      Provides an interactive TUI and automation-friendly JSON/robot modes.
#
#   5) CASS Memory (cm) - Procedural Memory for Agents
#      https://github.com/Dicklesworthstone/cass_memory_system
#      A "procedural memory" layer that turns past coding sessions into a
#      searchable playbook of rules and anti-patterns. Helps agents reuse
#      proven patterns instead of reinventing.
#
#   6) CAAM - Coding Agent Account Manager
#      https://github.com/Dicklesworthstone/coding_agent_account_manager
#      A utility for instantly switching between multiple authenticated
#      accounts for subscription-based AI coding CLIs by backing up and
#      restoring local auth files. Supports cooldown tracking and rotation.
#
#   7) RU - Repo Updater
#      https://github.com/Dicklesworthstone/repo_updater
#      An automation-friendly CLI for keeping many GitHub repositories
#      synchronized. Clones missing repos, pulls updates, detects diverged/
#      dirty/conflict states, and prints actionable resolution commands.
#
#   8) DCG - Destructive Command Guard
#      https://github.com/Dicklesworthstone/destructive_command_guard
#      A safety hook to intercept and block destructive shell/git commands
#      before they execute in agent-driven workflows. Provides explanations
#      and safer alternatives via an "explain" mode.
#
#   9) MCP Agent Mail (mcp_agent_mail) - INSTALLED LAST
#      https://github.com/Dicklesworthstone/mcp_agent_mail
#      A mailbox-style coordination system for coding agents supporting
#      messaging, acknowledgements, and advisory file reservations. Stores
#      state in SQLite while writing human-auditable artifacts into Git.
#      NOTE: Requires per-repo registration; typically updated manually.
#
# =============================================================================

log() { printf "%s\n" "$*" >&2; }
die() { log "ERROR: $*"; exit 1; }

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"
}

run_bash() {
  # Prefer bash for curl|bash installers; fall back to sh.
  if command -v bash >/dev/null 2>&1; then
    bash -lc "$*"
  else
    sh -lc "$*"
  fi
}

epoch() { date +%s; }

# Yellow "==> " indicator
yellow() {
  # ANSI yellow: 33
  printf "\033[33m==> %s\033[0m\n" "$*" >&2
}

preflight() {
  need_cmd curl
  need_cmd uv
  need_cmd python3
}

# ---- per-tool install/update ----

# NTM
# Repo URL: https://github.com/Dicklesworthstone/ntm
install_ntm() {
  yellow "Installing NTM"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  run_bash 'curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/ntm/main/install.sh | bash'
  cd "$_orig_dir"
}
update_ntm() {
  yellow "Updating NTM"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  if command -v ntm >/dev/null 2>&1; then
    run_bash 'ntm upgrade --yes'
  else
    install_ntm
  fi
  cd "$_orig_dir"
}

# SLB
# Repo URL: https://github.com/Dicklesworthstone/slb
install_slb() {
  yellow "Installing SLB"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  run_bash 'curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/slb/main/scripts/install.sh | bash'
  cd "$_orig_dir"
}
update_slb() {
  yellow "Updating SLB"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  run_bash 'curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/slb/main/scripts/install.sh | bash'
  cd "$_orig_dir"
}

# UBS
# Repo URL: https://github.com/Dicklesworthstone/ultimate_bug_scanner
install_ubs() {
  yellow "Installing UBS"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  run_bash "curl -fsSL \"https://raw.githubusercontent.com/Dicklesworthstone/ultimate_bug_scanner/master/install.sh?$(epoch)\" | bash -s --"
  cd "$_orig_dir"
}
update_ubs() {
  yellow "Updating UBS"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  run_bash "curl -fsSL \"https://raw.githubusercontent.com/Dicklesworthstone/ultimate_bug_scanner/master/install.sh?$(epoch)\" | bash -s --"
  cd "$_orig_dir"
}

# CASS
# Repo URL: https://github.com/Dicklesworthstone/coding_agent_session_search
install_cass() {
  yellow "Installing CASS"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  run_bash 'curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/coding_agent_session_search/main/install.sh | bash -s -- --easy-mode --verify'
  cd "$_orig_dir"
}
update_cass() {
  yellow "Updating CASS"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  run_bash 'curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/coding_agent_session_search/main/install.sh | bash -s -- --easy-mode --verify'
  cd "$_orig_dir"
}

# CASS Memory
# Repo URL: https://github.com/Dicklesworthstone/cass_memory_system
install_cass_memory() {
  yellow "Installing CASS Memory"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  run_bash 'curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/cass_memory_system/main/install.sh | bash -s -- --easy-mode --verify'
  cd "$_orig_dir"
}
update_cass_memory() {
  yellow "Updating CASS Memory"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  run_bash 'curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/cass_memory_system/main/install.sh | bash -s -- --easy-mode --verify'
  cd "$_orig_dir"
}

# CAAM
# Repo URL: https://github.com/Dicklesworthstone/coding_agent_account_manager
install_caam() {
  yellow "Installing CAAM"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  run_bash "curl -fsSL \"https://raw.githubusercontent.com/Dicklesworthstone/coding_agent_account_manager/main/install.sh?$(epoch)\" | bash"
  cd "$_orig_dir"
}
update_caam() {
  yellow "Updating CAAM"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  run_bash "curl -fsSL \"https://raw.githubusercontent.com/Dicklesworthstone/coding_agent_account_manager/main/install.sh?$(epoch)\" | bash"
  cd "$_orig_dir"
}

# RU
# Repo URL: https://github.com/Dicklesworthstone/repo_updater
install_ru() {
  yellow "Installing RU"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  run_bash "curl -fsSL \"https://raw.githubusercontent.com/Dicklesworthstone/repo_updater/main/install.sh?ru_cb=$(epoch)\" | bash"
  cd "$_orig_dir"
}
update_ru() {
  yellow "Updating RU"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  if command -v ru >/dev/null 2>&1; then
    run_bash 'ru self-update'
  else
    install_ru
  fi
  cd "$_orig_dir"
}

# DCG
# Repo URL: https://github.com/Dicklesworthstone/destructive_command_guard
install_dcg() {
  yellow "Installing DCG"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  run_bash "curl -fsSL \"https://raw.githubusercontent.com/Dicklesworthstone/destructive_command_guard/master/install.sh?$(epoch)\" | bash -s -- --easy-mode"
  cd "$_orig_dir"
}
update_dcg() {
  yellow "Updating DCG"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  if command -v dcg >/dev/null 2>&1; then
    run_bash 'dcg update'
  else
    install_dcg
  fi
  cd "$_orig_dir"
}

# MCP Agent Mail (LAST)
# Repo URL: https://github.com/Dicklesworthstone/mcp_agent_mail
#
# NOTE: Keep these commands here for reference, but this component should be
# updated manually (because it is commonly wired per-repo via registrations and
# optional guards).
install_mcp_agent_mail() {
  yellow "Installing MCP Agent Mail (mcp_agent_mail) — SKIPPED (manual)"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  # Manual install:
  run_bash "curl -fsSL \"https://raw.githubusercontent.com/Dicklesworthstone/mcp_agent_mail/main/scripts/install.sh?$(epoch)\" | bash -s -- --yes"
  cd "$_orig_dir"
}
update_mcp_agent_mail() {
  yellow "Updating MCP Agent Mail (mcp_agent_mail) — SKIPPED (manual)"
  local _orig_dir="$(pwd)"
  cd "$HOME"
  # Manual update (re-run installer):
  run_bash "curl -fsSL \"https://raw.githubusercontent.com/Dicklesworthstone/mcp_agent_mail/main/scripts/install.sh?$(epoch)\" | bash -s -- --yes"
  cd "$_orig_dir"
}

# ---- orchestration ----
install_all() {
  log "Installing Dicklesworthstone stack..."
  install_ntm         # Named Tmux Manager
  install_slb         # Simultaneous Launch Button
  install_ubs         # Ultimate Bug Scanner
  install_cass        # Coding Agent Session Search
  install_cass_memory # CASS Memory (cm)
  install_caam        # Coding Agent Account Manager
  install_ru          # Repo Updater
  install_dcg         # Destructive Command Guard
  # install_mcp_agent_mail   # MCP Agent Mail (manual)
  log "Done."
}

update_all() {
  log "Updating Dicklesworthstone stack..."
  update_ntm         # Named Tmux Manager
  update_slb         # Simultaneous Launch Button
  update_ubs         # Ultimate Bug Scanner
  update_cass        # Coding Agent Session Search
  update_cass_memory # CASS Memory (cm)
  update_caam        # Coding Agent Account Manager
  update_ru          # Repo Updater
  update_dcg         # Destructive Command Guard
  update_mcp_agent_mail    # MCP Agent Mail (manual)
  log "Done."
}

usage() {
  cat <<'EOF'
Usage:
  dicklesworthstone-stack.sh install   # install all components (from $HOME)
  dicklesworthstone-stack.sh update    # update all components (from $HOME)
  dicklesworthstone-stack.sh help

Assumes:
  - uv, python3, curl are already installed and on PATH.

Notes:
  - MCP Agent Mail is intentionally skipped by default; see the script comments
    for the manual install/update one-liners.
EOF
}

preflight

cmd="${1:-help}"
case "$cmd" in
  install) install_all ;;
  update)  update_all ;;
  help|-h|--help) usage ;;
  *) die "Unknown command: $cmd (try: help)" ;;
esac
