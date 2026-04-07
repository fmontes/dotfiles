#!/usr/bin/env zsh
if [[ ! -d "$HOME/.nvm" ]]; then
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  echo "nvm installed. Run 'nvm install --lts' after restarting your shell."
else
  echo "nvm already installed."
fi
