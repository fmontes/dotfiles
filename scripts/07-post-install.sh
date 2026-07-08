#!/usr/bin/env zsh

# ─── gh-dash extension ───────────────────────────────────────────────────────
if command -v gh &>/dev/null; then
  echo "Installing gh-dash extension..."
  gh extension install dlvhdr/gh-dash 2>/dev/null || echo "gh-dash already installed or gh not authenticated yet"
fi

# ─── Claude Code (native installer) ──────────────────────────────────────────
# Use the official native installer rather than the npm package — the npm
# global install can skip the platform-native binary (--ignore-scripts /
# --omit=optional), leaving a `claude` on PATH that exists but won't run.
# The installer drops the binary in ~/.local/bin, which this script's PATH
# may not include yet — add it so the run-check and verification work here.
export PATH="$HOME/.local/bin:$PATH"
# Test that it actually runs, not just that it's present, so a broken npm
# install gets replaced.
if claude --version &>/dev/null; then
  echo "Claude Code already installed."
else
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash || echo "Claude Code install failed — run 'curl -fsSL https://claude.ai/install.sh | bash' manually."
  if claude --version &>/dev/null; then
    echo "Claude Code ready."
  else
    echo "Claude Code still not runnable — check ~/.local/bin/claude manually."
  fi
fi

# ─── Global npm packages ─────────────────────────────────────────────────────
if command -v npm &>/dev/null; then
  echo "Installing global npm packages..."
  npm install -g @angular/cli @fmontes/md2clip dev-browser yarn
else
  echo "npm not available yet — skipping global packages. Run manually after mise sets up Node."
fi

# ─── chai: sync AI agent config to all platforms ─────────────────────────────
# Distributes ai/instructions, ai/skills, and ai/subagents (plus external deps
# declared in chai.toml) to every configured agent platform.
if command -v chai &>/dev/null; then
  echo "Syncing AI agent config with chai..."
  chai update || echo "chai update failed — run 'chai update' manually."
  chai sync   || echo "chai sync failed — run 'chai sync' manually."
else
  echo "chai not available yet — run 'chai update && chai sync' after Homebrew finishes."
fi

# ─── Fix .netrc permissions ──────────────────────────────────────────────────
if [[ -f "$HOME/.netrc" ]]; then
  chmod 600 "$HOME/.netrc"
  echo ".netrc permissions fixed."
fi

# ─── VS Code CLI symlink ─────────────────────────────────────────────────────
code_bin="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
if [[ -f "$code_bin" ]]; then
  echo "Setting up VS Code CLI symlink..."
  sudo mkdir -p /usr/local/bin
  if sudo ln -sf "$code_bin" /usr/local/bin/code; then
    echo "VS Code CLI ready."
  else
    echo "VS Code CLI symlink failed."
  fi
fi

# ─── Manual steps ────────────────────────────────────────────────────────────
echo ""
echo "======================================"
echo "  Manual Steps Required"
echo "======================================"
echo ""
echo "1. Install 1Password and sign in"
echo "2. Generate SSH key and add to GitHub:"
echo "   ssh-keygen -t ed25519 -C 'your@email.com'"
echo "   https://github.com/settings/keys"
echo "3. Update name and email in ~/.gitconfig"
echo "4. gh auth login"
echo "5. atuin login  (optional, for cross-machine history sync)"
echo "6. Sign in to Raycast to restore extensions"
echo ""
