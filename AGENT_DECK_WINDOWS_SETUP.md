# Agent Deck Windows Setup Notes

Date: 2026-05-13

## What Agent Deck Is

Agent Deck is a terminal session manager for AI coding agents. It provides one TUI for tools such as Claude Code, Codex, Gemini, OpenCode, Cursor, and custom commands. It is built in Go with Charmbracelet Bubble Tea and uses tmux for the actual terminal sessions.

The upstream repository I found is:

https://github.com/asheshgoplani/agent-deck

I did not find a credible Arc Forge-owned Agent Deck repository. Search results and the current project documentation point to the `asheshgoplani/agent-deck` repo.

## Current Machine State

- Repo cloned to `C:\Users\eliro\Repos\AgentDeck`
- Cloned commit: `e30d78a`
- Latest upstream release checked via GitHub API: `v1.9.1`
- Windows has Git, Go, tmux-win32, Codex CLI, and Claude Code installed.
- Native Windows install does not work: the Go code uses Unix-only process/socket syscalls.
- Official support path is Windows via WSL.
- Ubuntu app package is present.
- WSL optional component enablement is pending a Windows reboot.

## Why Reboot Is Required

Running:

```powershell
wsl.exe --install -d Ubuntu --no-launch
```

returned that the requested operation completed, but changes will not be effective until the system is rebooted. Until then, WSL commands fail with:

```text
WSL_E_WSL_OPTIONAL_COMPONENT_REQUIRED
```

## Finish After Reboot

After restarting Windows:

1. Open Ubuntu from the Start menu.
2. Create the Linux username and password when prompted.
3. Open PowerShell and run:

```powershell
cd C:\Users\eliro\Repos\AgentDeck
.\finish-agent-deck-wsl.ps1
```

The script installs:

- `curl`, `ca-certificates`, `git`, `tmux`, `jq`
- Node.js 22
- `@openai/codex`
- `@anthropic-ai/claude-code`
- Agent Deck via the official installer

## Launch

From PowerShell:

```powershell
wsl.exe -d Ubuntu
agent-deck
```

Or launch the browser UI from inside Ubuntu:

```bash
agent-deck web --listen 127.0.0.1:8420
```

Then open:

```text
http://127.0.0.1:8420
```

## Useful Commands

```bash
agent-deck version
agent-deck status
agent-deck add . -c claude
agent-deck add . -c codex
agent-deck web
```
