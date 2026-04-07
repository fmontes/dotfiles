#!/usr/bin/env zsh
echo ""
echo "======================================"
echo "  Manual Steps Required"
echo "======================================"
echo ""
echo "1. Install 1Password and sign in"
echo "2. SSH keys: ssh-keygen -t ed25519 -C 'your@email.com'"
echo "   Then add to GitHub: https://github.com/settings/keys"
echo "3. Update name and email in ~/.gitconfig"
echo "4. gh auth login"
echo "5. mise use --global node@lts"
echo "   Then install global npm packages:"
echo "   npm install -g @anthropic-ai/claude-code @angular/cli @fmontes/md2clip dev-browser yarn"
echo "6. mise use --global python@latest"
echo "7. atuin login  # optional, for cross-machine history sync"
echo "8. Sign in to Raycast to restore extensions"
echo ""

# gh-dash extension
if command -v gh &>/dev/null; then
  echo "Installing gh-dash extension..."
  gh extension install dlvhdr/gh-dash 2>/dev/null || echo "gh-dash already installed or gh not authenticated yet"
fi

# cmux CLI symlink
if [[ -f "/Applications/cmux.app/Contents/Resources/bin/cmux" ]]; then
  echo "Setting up cmux CLI symlink..."
  sudo ln -sf "/Applications/cmux.app/Contents/Resources/bin/cmux" /usr/local/bin/cmux
  echo "cmux CLI ready."
fi
echo ""
