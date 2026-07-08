#!/usr/bin/env zsh
if xcode-select -p &>/dev/null && command -v git &>/dev/null; then
  echo "Xcode CLT already installed."
  return 0 2>/dev/null || exit 0
fi

echo "Installing Xcode Command Line Tools..."
xcode-select --install 2>/dev/null || true

# The install runs in a separate GUI process, so poll until git actually
# works rather than trusting a keypress — otherwise later steps race a
# half-finished CLT install.
echo "Waiting for the Command Line Tools install to finish (accept the popup)..."
until xcode-select -p &>/dev/null && command -v git &>/dev/null; do
  sleep 5
done
echo "Xcode CLT ready."
