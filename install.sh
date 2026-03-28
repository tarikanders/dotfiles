#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[dotfiles] Installation démarrée..."

# ── 1. Claude Code ──────────────────────────────────────────────────────────
echo "[dotfiles] Configuration Claude Code..."
mkdir -p "$HOME/.claude/hooks"

cp "$DOTFILES_DIR/claude/settings.json"        "$HOME/.claude/settings.json"
cp "$DOTFILES_DIR/claude/CLAUDE.md"            "$HOME/.claude/CLAUDE.md"
cp "$DOTFILES_DIR/claude/RTK.md"               "$HOME/.claude/RTK.md"
cp "$DOTFILES_DIR/claude/hooks/rtk-rewrite.sh" "$HOME/.claude/hooks/rtk-rewrite.sh"
chmod +x "$HOME/.claude/hooks/rtk-rewrite.sh"

# ── 2. RTK (Rust Token Killer) ───────────────────────────────────────────────
if ! command -v rtk &>/dev/null; then
  echo "[dotfiles] Installation de RTK..."
  if command -v cargo &>/dev/null; then
    cargo install rtk
  else
    curl -fsSL https://github.com/rtk-ai/rtk/releases/latest/download/rtk-x86_64-unknown-linux-musl.tar.gz \
      | tar -xz -C "$HOME/.local/bin"
    chmod +x "$HOME/.local/bin/rtk"
  fi
  echo "[dotfiles] RTK installé."
else
  echo "[dotfiles] RTK déjà installé ($(rtk --version 2>/dev/null))."
fi

# ── 3. Git ───────────────────────────────────────────────────────────────────
echo "[dotfiles] Configuration Git..."
cp "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# ── 4. VSCode keybindings ────────────────────────────────────────────────────
echo "[dotfiles] Configuration VSCode..."
mkdir -p "$HOME/.config/Code/User"
cp "$DOTFILES_DIR/vscode/keybindings.json" "$HOME/.config/Code/User/keybindings.json"

# ── 5. Extensions VSCode ─────────────────────────────────────────────────────
if command -v code &>/dev/null; then
  echo "[dotfiles] Installation des extensions VSCode..."
  code --install-extension shd101wyy.markdown-preview-enhanced --force
  code --install-extension anthropic.claude-code --force
fi

echo "[dotfiles] Terminé !"
