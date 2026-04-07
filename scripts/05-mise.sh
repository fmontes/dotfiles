#!/usr/bin/env zsh

if ! command -v mise &>/dev/null; then
  echo "mise not found. Was it installed via Homebrew?"
  exit 1
fi

echo "Setting up mise runtimes..."

eval "$(mise activate zsh)"

mise use --global node@lts
mise use --global python@latest

echo "mise runtimes ready."
echo "  node: $(mise exec node -- node --version)"
echo "  python: $(mise exec python -- python --version)"
