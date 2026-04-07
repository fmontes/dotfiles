#!/usr/bin/env zsh
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  echo "Press any key once installation completes..."
  read -k 1
else
  echo "Xcode CLT already installed."
fi
