#!/usr/bin/env zsh
echo ""
echo "======================================"
echo "  Manual Steps Required"
echo "======================================"
echo ""
echo "1. Install 1Password and sign in"
echo "2. Copy home/.npmrc.template to ~/.npmrc and fill tokens from 1Password"
echo "3. SSH keys: ssh-keygen -t ed25519 -C 'your@email.com'"
echo "   Then add to GitHub: https://github.com/settings/keys"
echo "4. Update name and email in ~/.gitconfig"
echo "5. gh auth login"
echo "6. nvm install --lts && nvm use --lts"
echo "   Then install global npm packages:"
echo "   npm install -g @anthropic-ai/claude-code @angular/cli @fmontes/md2clip dev-browser yarn"
echo "6. Sign in to Raycast to restore extensions"
echo ""

# cmux CLI symlink
if [[ -f "/Applications/cmux.app/Contents/Resources/bin/cmux" ]]; then
  echo "Setting up cmux CLI symlink..."
  sudo ln -sf "/Applications/cmux.app/Contents/Resources/bin/cmux" /usr/local/bin/cmux
  echo "cmux CLI ready."
fi
echo ""
