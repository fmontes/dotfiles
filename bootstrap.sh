#!/usr/bin/env bash
set -e

REPO="https://github.com/fmontes/dotfiles.git"
DEST="$HOME/.dotfiles"

info()  { printf "\033[0;32m==>\033[0m %s\n" "$1"; }
error() { printf "\033[0;31m==>\033[0m %s\n" "$1"; exit 1; }

if ! xcode-select -p >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1; then
  info "Xcode Command Line Tools (provides git) not found. Installing..."
  xcode-select --install >/dev/null 2>&1 || true
  info "Accept the popup. Waiting for the install to finish..."
  until xcode-select -p >/dev/null 2>&1 && command -v git >/dev/null 2>&1; do
    sleep 5
  done
  info "Command Line Tools ready."
fi

if [[ -d "$DEST" ]]; then
  info "Updating existing $DEST..."
  git -C "$DEST" pull --ff-only
else
  info "Cloning $REPO into $DEST..."
  git clone "$REPO" "$DEST"
fi

info "Running installer..."
cd "$DEST"
exec ./install.sh </dev/tty
