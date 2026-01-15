# Dicklesworthstone Stack

A curated set of command-line utilities from the Dicklesworthstone "Agent Flywheel" software ecosystem for AI-assisted development workflows.

- **Website:** https://agent-flywheel.com/
- **Setup Repo:** https://github.com/Dicklesworthstone/agentic_coding_flywheel_setup
- **Author:** https://github.com/Dicklesworthstone

> **⚠️ Important:** This stack is designed as a comprehensive suite—not a one-click solution. Before running the installer script, review the `install_all()` and `update_all()` functions to understand which components will be installed. Each tool serves a specific purpose, and you may not need all of them. To customize your installation, simply comment out any unwanted components in these orchestration functions before running the script.

## Table of Contents

- [Dicklesworthstone Stack](#dicklesworthstone-stack)
  - [Table of Contents](#table-of-contents)
  - [Stack Components (recommended order)](#stack-components-recommended-order)
  - [Global assumptions](#global-assumptions)
  - [Install scope: user root vs per-repository](#install-scope-user-root-vs-per-repository)
    - [User-root (global) install/update](#user-root-global-installupdate)
    - [Per-repository steps required (in addition to global install)](#per-repository-steps-required-in-addition-to-global-install)
  - [1) NTM (Named Tmux Manager)](#1-ntm-named-tmux-manager)
  - [2) SLB (Simultaneous Launch Button)](#2-slb-simultaneous-launch-button)
  - [3) UBS (Ultimate Bug Scanner)](#3-ubs-ultimate-bug-scanner)
  - [4) CASS (coding-agent-search)](#4-cass-coding-agent-search)
  - [5) CASS Memory (cm)](#5-cass-memory-cm)
  - [6) CAAM (Coding Agent Account Manager)](#6-caam-coding-agent-account-manager)
  - [7) RU (repo\_updater)](#7-ru-repo_updater)
  - [8) BV (Beads Viewer)](#8-bv-beads-viewer)
  - [9) MS (Meta Skill)](#9-ms-meta-skill)
  - [10) DCG (Destructive Command Guard)](#10-dcg-destructive-command-guard)
  - [11) MCP Agent Mail (mcp\_agent\_mail)](#11-mcp-agent-mail-mcp_agent_mail)
    - [Install (one-line installer)](#install-one-line-installer)
    - [Update](#update)
    - [Running MCP Agent Mail (the `am` command)](#running-mcp-agent-mail-the-am-command)
    - [Implementation details: registering repositories (ensure\_project / register\_agent)](#implementation-details-registering-repositories-ensure_project--register_agent)
    - [Optional: pre-commit guards (per-repository)](#optional-pre-commit-guards-per-repository)
    - [Prerequisites](#prerequisites)

---

## Stack Components (recommended order)

1. **NTM** (Named Tmux Manager)
2. **SLB** (Simultaneous Launch Button)
3. **UBS** (Ultimate Bug Scanner)
4. **CASS** (coding-agent-search)
5. **CASS Memory** (cm)
6. **CAAM** (Coding Agent Account Manager)
7. **RU** (repo_updater)
8. **BV** (Beads Viewer)
9. **MS** (Meta Skill)
10. **DCG** (Destructive Command Guard)
11. **MCP Agent Mail (mcp_agent_mail)** (installed/updated last; per-repo registration)

---

## Global assumptions

This stack assumes the following are already installed and available on your `PATH`:

- `uv`
- `python3`
- `curl`
- `bash` (recommended; `sh` fallback works for most installers)

---

## Install scope: user root vs per-repository

Some tools are installed **once per user** (global CLI + home-directory config), while others require **per-repository setup** (creating repo-local state, hooks, or registrations).

### User-root (global) install/update

These are primarily installed into a user-level bin directory (or similar) and keep their config/state under `$HOME`:

- **NTM**
- **CASS**
- **CASS Memory**
- **CAAM**
- **RU**
- **BV**
- **MS**
- **DCG** (also wires into agent settings under your home directory)

### Per-repository steps required (in addition to global install)

These tools have repo-local initialization, hooks, or registrations:

- **SLB** — requires per-repo initialization (creates `.slb/` state in the repository).
- **UBS** — optional per-repo git hook wiring (pre-commit lives inside each repo’s `.git/hooks/`).
- **MCP Agent Mail** — per-repo registration using `ensure_project`/`register_agent` with the repo’s absolute path as identity; optional per-repo pre-commit guard installation.

---

## 1) NTM (Named Tmux Manager)

- **Repo URL:** https://github.com/Dicklesworthstone/ntm
- **Overview:** A tmux-based session manager for running and supervising multiple AI coding agents in parallel. It provides dashboards, activity/health monitoring, output streaming, and tooling to search/extract/diff agent output. It also supports automation-oriented “robot mode” commands for scripting and integrations.
- **Install (user-root):**

  ```sh
  curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/ntm/main/install.sh | bash
  ```

- **Update (user-root):**

  ```sh
  ntm upgrade --yes
  ```

- **Homebrew / brew:** Not provided as a brew formula in the repo materials used here.
- **Prerequisites:**
  - `curl`, `bash` (recommended)

---

## 2) SLB (Simultaneous Launch Button)

- **Repo URL:** https://github.com/Dicklesworthstone/slb
- **Overview:** A two-person-rule CLI for AI agent workflows that gates potentially destructive commands behind explicit peer review. It classifies commands into risk tiers, tracks approvals in a local SQLite state store, and can surface pending requests via a TUI/daemon. The goal is to add auditable friction before irreversible actions (e.g., `rm -rf`, `git push --force`, `kubectl delete`).
- **Install (user-root):**

  ```sh
  curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/slb/main/scripts/install.sh | bash
  ```

- **Update (user-root):**

  ```sh
  curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/slb/main/scripts/install.sh | bash
  ```

- **Per-repository setup (required):**
  - Run SLB’s repo initialization inside each repository you want protected. This creates repo-local state (commonly a `.slb/` directory and related state DB) in that repository.
- **Homebrew / brew:** Not provided as a brew formula in the repo materials used here.
- **Prerequisites:**
  - `curl`, `bash` (recommended)
  - Git repos you want to protect (per-repo init is run from inside each repo)

---

## 3) UBS (Ultimate Bug Scanner)

- **Repo URL:** https://github.com/Dicklesworthstone/ultimate_bug_scanner
- **Overview:** A fast, multi-language bug scanner designed to catch common production issues (and many subtle ones) with a single command. It ships as a unified CLI that can emit CI-friendly output and machine-readable reports for automation. It’s optimized for AI-assisted development workflows where you want quick feedback before shipping or committing.
- **Install (user-root):**

  ```sh
  curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/ultimate_bug_scanner/master/install.sh?$(date +%s)" \
    | bash -s --
  ```

- **Update (user-root):**

  ```sh
  curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/ultimate_bug_scanner/master/install.sh?$(date +%s)" \
    | bash -s --
  ```

- **Per-repository setup (optional but common):**
  - Any pre-commit hook wiring is installed into a repo’s `.git/hooks/pre-commit`, which is inherently per-repo. If you want UBS to run on every commit, you must enable the hook per repository.
- **Homebrew / brew (commonly used dependencies):**

  ```sh
  brew install ast-grep
  brew install ripgrep
  brew install typos-cli
  ```

- **Prerequisites:**
  - `curl`, `bash` (recommended)
  - Optional: `ast-grep`, `ripgrep`, `typos-cli`

---

## 4) CASS (coding-agent-search)

- **Repo URL:** https://github.com/Dicklesworthstone/coding_agent_session_search
- **Overview:** A unified search/index tool for your local coding-agent history across multiple assistants and tools (e.g., Claude Code, Codex, Gemini, Cursor, Aider, etc.). It provides an interactive TUI as well as automation-friendly JSON/robot modes for scripting and pipelines. It’s useful for finding “we solved this before” context, debugging archaeology, and cross-agent knowledge transfer.
- **Install (user-root):**

  ```sh
  curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/coding_agent_session_search/main/install.sh \
    | bash -s -- --easy-mode --verify
  ```

- **Update (user-root):**

  ```sh
  curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/coding_agent_session_search/main/install.sh \
    | bash -s -- --easy-mode --verify
  ```

- **Homebrew / brew:** Not provided as a brew formula in the repo materials used here.
- **Prerequisites:**
  - `curl`, `bash` (recommended)

---

## 5) CASS Memory (cm)

- **Repo URL:** https://github.com/Dicklesworthstone/cass_memory_system
- **Overview:** A “procedural memory” layer for agents that turns past coding sessions into a searchable playbook of rules and anti-patterns. The primary workflow is asking for task-specific context (rules + relevant history snippets) before starting non-trivial work, so you reuse proven patterns instead of reinventing. It also includes onboarding/doctor tooling and can expose functionality via an MCP server for integrations.
- **Install (user-root):**

  ```sh
  curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/cass_memory_system/main/install.sh \
    | bash -s -- --easy-mode --verify
  ```

- **Update (user-root):**

  ```sh
  curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/cass_memory_system/main/install.sh \
    | bash -s -- --easy-mode --verify
  ```

- **Homebrew / brew:** Not provided as a brew formula in the repo materials used here.
- **Prerequisites:**
  - `curl`, `bash` (recommended)
  - CASS installed
  - Optional LLM API key(s): `ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, `GOOGLE_GENERATIVE_AI_API_KEY`

---

## 6) CAAM (Coding Agent Account Manager)

- **Repo URL:** https://github.com/Dicklesworthstone/coding_agent_account_manager
- **Overview:** A utility for instantly switching between multiple authenticated accounts for subscription-based AI coding CLIs by backing up and restoring their local auth files. It removes the repeated browser/OAuth “log out and log in” loop by treating auth state as file snapshots you can activate in milliseconds. It also supports workflow helpers like cooldown tracking/rotation and wrappers for re-running commands after rate limits.
- **Install (user-root):**

  ```sh
  curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/coding_agent_account_manager/main/install.sh?$(date +%s)" | bash
  ```

- **Update (user-root):**

  ```sh
  curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/coding_agent_account_manager/main/install.sh?$(date +%s)" | bash
  ```

- **Homebrew / brew:** Not provided as a brew formula in the repo materials used here.
- **Prerequisites:**
  - `curl`, `bash` (recommended)

---

## 7) RU (repo_updater)

- **Repo URL:** https://github.com/Dicklesworthstone/repo_updater
- **Overview:** An automation-friendly CLI for keeping many GitHub repositories synchronized from a single command. It can clone missing repos, pull updates, detect diverged/dirty/conflict states, and print actionable resolution commands when things go wrong. It’s built for scripting (JSON output, meaningful exit codes, non-interactive mode) as well as pleasant interactive use.
- **Install (user-root):**

  ```sh
  curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/repo_updater/main/install.sh?ru_cb=$(date +%s)" | bash
  ```

- **Update (user-root):**

  ```sh
  ru self-update
  ```

- **Homebrew / brew:** Not provided as a brew formula in the repo materials used here.
- **Prerequisites:**
  - `curl`, `bash` (recommended)

---

## 8) BV (Beads Viewer)

- **Repo URL:** https://github.com/Dicklesworthstone/beads_viewer
- **Overview:** A fast terminal UI for browsing and managing tasks in projects that use the Beads issue tracker. It’s dependency-graph aware, so it can highlight bottlenecks, cycles, and critical paths instead of only showing a flat list. It also includes automation-friendly “robot” JSON outputs for scripting and AI agent workflows.
- **Prerequisites:**
  - [Beads (`bd`)](https://github.com/steveyegge/beads) installed via Homebrew via `brew install beads`
  - Beads-tracked repositories (i.e., repos with a `.beads/` directory and `beads.jsonl`/`issues.jsonl` file)

- **Install:**

  ```sh
  brew install beads_viewer
  ```

- **Update:**

  ```sh
  brew upgrade beads_viewer
  ```

- **Per-repository setup (required):**
  - Beads must be initialized in the repo (i.e., a `.beads/` directory with a `beads.jsonl`/`issues.jsonl` file). Once present, run `bv` from inside that repository to view it.

---

## 9) MS (Meta Skill)

- **Repo URL:** https://github.com/Dicklesworthstone/meta_skill
- **Overview:** A skill discovery and recommendation system for coding agents. It indexes available tools/skills and suggests relevant capabilities based on context, improving agent effectiveness across diverse tasks. Provides both interactive and automation-friendly modes for integration into agent workflows.
- **Install (user-root):**

  ```sh
  curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/meta_skill/main/install.sh?$(date +%s)" | bash
  ```

- **Update (user-root):**

  ```sh
  curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/meta_skill/main/install.sh?$(date +%s)" | bash
  ```

- **Homebrew / brew:** Not provided as a brew formula in the repo materials used here.
- **Prerequisites:**
  - `curl`, `bash` (recommended)

---

## 10) DCG (Destructive Command Guard)

- **Repo URL:** https://github.com/Dicklesworthstone/destructive_command_guard
- **Overview:** A safety hook designed to intercept and block destructive shell/git commands before they execute in agent-driven workflows. It aims to prevent catastrophic mistakes (like hard resets or recursive deletes) while providing clear explanations and safer alternatives via an “explain” mode. It can also scan repositories and integrate into CI/pre-commit flows for defense in depth.
- **Install (user-root):**

  ```sh
  curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/destructive_command_guard/master/install.sh?$(date +%s)" \
    | bash -s -- --easy-mode
  ```

- **Update (user-root):**

  ```sh
  dcg update
  ```

- **Homebrew / brew:** Not provided as a brew formula in the repo materials used here.
- **Prerequisites:**
  - `curl`, `bash` (recommended)
  - Optional: `gum`

---

## 11) MCP Agent Mail (mcp_agent_mail)

- **Repo URL:** https://github.com/Dicklesworthstone/mcp_agent_mail
- **Overview:** A mailbox-style coordination system for coding agents that supports messaging, acknowledgements, and advisory file reservations to reduce conflicting edits. It stores state in a local SQLite database while writing human-auditable artifacts into Git, making collaboration traceable and reviewable. It also includes CLI/server modes and tooling to export/share a static viewer bundle for audits or oversight.
- **Walkthrough Video:** Jeffery's MCP Agent Mail Walkthrough — https://youtube.com/watch?v=68VVcqMEDrs

### Install (one-line installer)

```sh
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/mcp_agent_mail/main/scripts/install.sh?$(date +%s)" \
  | bash -s -- --yes
```

### Update

```sh
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/mcp_agent_mail/main/scripts/install.sh?$(date +%s)" \
  | bash -s -- --yes
```

### Running MCP Agent Mail (the `am` command)

After installation, MCP Agent Mail is typically invoked via the `am` CLI.

Common patterns:

- **Show help / available subcommands**

  ```sh
  am --help
  ```

- **Start the MCP server over stdio** (common for integrating with agent tooling)

  ```sh
  am serve-stdio
  ```

- **Sanity-check that the CLI is installed and reachable**

  ```sh
  command -v am
  am --version
  ```

### Implementation details: registering repositories (ensure_project / register_agent)

Register each code repository you want MCP Agent Mail to manage:

- Use the repo’s **absolute path** as the `project_key`.
- Create/load the project with `ensure_project(project_key=<ABSOLUTE_REPO_PATH>)`.
- Associate agent/tool registrations with `register_agent(project_key=<ABSOLUTE_REPO_PATH>, ...)`.

### Optional: pre-commit guards (per-repository)

Pre-commit guards (if enabled) are installed per repository and can enforce safety and hygiene (secrets scanning, large-file blocks, formatting/lint/typecheck gates, etc.).

### Prerequisites

- `uv`
- `python3`
