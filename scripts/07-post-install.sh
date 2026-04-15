#!/usr/bin/env zsh

# ─── gh-dash extension ───────────────────────────────────────────────────────
if command -v gh &>/dev/null; then
  echo "Installing gh-dash extension..."
  gh extension install dlvhdr/gh-dash 2>/dev/null || echo "gh-dash already installed or gh not authenticated yet"
fi

# ─── Global npm packages ─────────────────────────────────────────────────────
if command -v npm &>/dev/null; then
  echo "Installing global npm packages..."
  npm install -g @anthropic-ai/claude-code @angular/cli @fmontes/md2clip dev-browser yarn
else
  echo "npm not available yet — skipping global packages. Run manually after mise sets up Node."
fi

# ─── Fix .netrc permissions ──────────────────────────────────────────────────
if [[ -f "$HOME/.netrc" ]]; then
  chmod 600 "$HOME/.netrc"
  echo ".netrc permissions fixed."
fi

# ─── cmux CLI symlink ────────────────────────────────────────────────────────
if [[ -f "/Applications/cmux.app/Contents/Resources/bin/cmux" ]]; then
  echo "Setting up cmux CLI symlink..."
  sudo mkdir -p /usr/local/bin
  if sudo ln -sf "/Applications/cmux.app/Contents/Resources/bin/cmux" /usr/local/bin/cmux; then
    echo "cmux CLI ready."
  else
    echo "cmux CLI symlink failed."
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
