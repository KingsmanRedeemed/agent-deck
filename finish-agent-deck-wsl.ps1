# Run this after rebooting Windows to finish Agent Deck setup inside Ubuntu WSL.
# It installs the Linux dependencies, Agent Deck, and Linux CLI versions of Codex/Claude.

$ErrorActionPreference = "Stop"

function Run-Wsl {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Command
    )

    wsl.exe -d Ubuntu -- bash -lc $Command
}

Write-Host "Checking Ubuntu WSL..."
wsl.exe -d Ubuntu -- bash -lc "printf 'Ubuntu WSL OK: '; uname -sr"
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Ubuntu has not completed first-run setup yet."
    Write-Host "Open Ubuntu from the Start menu once, create the Linux username/password, then rerun this script."
    exit 1
}

Write-Host "Installing base packages..."
Run-Wsl "sudo apt-get update && sudo apt-get install -y curl ca-certificates git tmux jq"

Write-Host "Installing Node.js 22 LTS for the AI agent CLIs..."
Run-Wsl "if ! command -v node >/dev/null 2>&1 || ! node -v | grep -q '^v22\.'; then curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - && sudo apt-get install -y nodejs; fi"

Write-Host "Installing Codex CLI and Claude Code inside WSL..."
Run-Wsl "sudo npm install -g @openai/codex @anthropic-ai/claude-code"

Write-Host "Installing Agent Deck..."
Run-Wsl "curl -fsSL https://raw.githubusercontent.com/asheshgoplani/agent-deck/main/install.sh | bash -s -- --non-interactive"

Write-Host "Verifying install..."
Run-Wsl "export PATH=\"\$HOME/.local/bin:\$PATH\"; agent-deck version; tmux -V; codex --version; claude --version"

Write-Host ""
Write-Host "Agent Deck is installed in Ubuntu WSL."
Write-Host "Launch it with:"
Write-Host "  wsl.exe -d Ubuntu"
Write-Host "  agent-deck"
Write-Host ""
Write-Host "For the web UI:"
Write-Host "  agent-deck web --listen 127.0.0.1:8420"
