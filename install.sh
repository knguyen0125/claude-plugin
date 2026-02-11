#!/usr/bin/env bash
set -euo pipefail

REPO="knguyen0125/claude-plugin"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()  { echo -e "${BLUE}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# ---------------------------------------------------------------------------
# 1. Ensure Claude Code is installed
# ---------------------------------------------------------------------------
info "Checking for Claude Code..."
if command -v claude &>/dev/null; then
  ok "Claude Code found: $(claude --version 2>/dev/null || echo 'unknown version')"
else
  warn "Claude Code not found. Installing..."
  curl -fsSL https://claude.ai/install.sh | bash
  export PATH="$HOME/.local/bin:$PATH"
  command -v claude &>/dev/null || error "Claude Code installation failed."
  ok "Claude Code installed: $(claude --version 2>/dev/null)"
fi

# ---------------------------------------------------------------------------
# 2. Ensure OpenCode is installed
# ---------------------------------------------------------------------------
info "Checking for OpenCode..."
if command -v opencode &>/dev/null; then
  ok "OpenCode found"
else
  warn "OpenCode not found. Installing..."
  curl -fsSL https://opencode.ai/install | bash
  # Refresh PATH in case the installer added a new directory
  export PATH="$HOME/.opencode/bin:$PATH"
  command -v opencode &>/dev/null || error "OpenCode installation failed."
  ok "OpenCode installed"
fi

# ---------------------------------------------------------------------------
# 3. Install marketplace + all plugins
# ---------------------------------------------------------------------------
info "Adding marketplace: ${REPO}..."
if claude plugin marketplace list 2>/dev/null | grep -q "knguyen0125"; then
  ok "Marketplace already added — updating..."
  claude plugin marketplace update knguyen0125
else
  claude plugin marketplace add "github:${REPO}"
fi

PLUGINS=("general" "engineering" "executive" "product")
for plugin in "${PLUGINS[@]}"; do
  info "Installing plugin: ${plugin}@knguyen0125..."
  if claude plugin list 2>/dev/null | grep -q "${plugin}@knguyen0125"; then
    ok "${plugin}@knguyen0125 already installed — updating..."
    claude plugin update "${plugin}@knguyen0125" --scope user || true
  else
    claude plugin install "${plugin}@knguyen0125" --scope user
  fi
done

ok "All plugins installed"

# ---------------------------------------------------------------------------
# 4. Install claude-mem marketplace + plugin
# ---------------------------------------------------------------------------
CLAUDE_MEM_REPO="thedotmack/claude-mem"
info "Adding marketplace: ${CLAUDE_MEM_REPO}..."
if claude plugin marketplace list 2>/dev/null | grep -q "thedotmack"; then
  ok "claude-mem marketplace already added — updating..."
  claude plugin marketplace update thedotmack
else
  claude plugin marketplace add "github:${CLAUDE_MEM_REPO}"
fi

info "Installing plugin: claude-mem@thedotmack..."
if claude plugin list 2>/dev/null | grep -q "claude-mem@thedotmack"; then
  ok "claude-mem@thedotmack already installed — updating..."
  claude plugin update "claude-mem@thedotmack" --scope user || true
else
  claude plugin install "claude-mem@thedotmack" --scope user
fi

ok "claude-mem installed"

# ---------------------------------------------------------------------------
# 5. Install CCS
# ---------------------------------------------------------------------------
info "Installing CCS (@kaitranntt/ccs)..."
npm install -g @kaitranntt/ccs
ok "CCS installed"

# ---------------------------------------------------------------------------
# 6. Install Playwright CLI
# ---------------------------------------------------------------------------
info "Installing Playwright CLI (@playwright/cli)..."
npm install -g @playwright/cli@latest
ok "Playwright CLI installed"

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo ""
ok "All done! Installed:"
echo "  - Claude Code"
echo "  - OpenCode"
echo "  - Marketplace: ${REPO} (plugins: ${PLUGINS[*]})"
echo "  - Marketplace: ${CLAUDE_MEM_REPO} (plugin: claude-mem)"
echo "  - CCS (@kaitranntt/ccs)"
echo "  - Playwright CLI (@playwright/cli)"
