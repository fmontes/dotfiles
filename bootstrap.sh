#!/usr/bin/env bash
set -e

REPO="https://github.com/fmontes/dotfiles.git"
DEST="$HOME/.dotfiles"

info()  { printf "\033[0;32m==>\033[0m %s\n" "$1"; }
error() { printf "\033[0;31m==>\033[0m %s\n" "$1"; exit 1; }

if ! xcode-select -p >/dev/null 2>&1; then
  info "Xcode Command Line Tools not found. Installing..."
  xcode-select --install || true
  error "Finish the Xcode CLT install in the popup, then re-run: curl -fsSL https://fmontes.com/install.sh | bash"
fi

if ! command -v git >/dev/null 2>&1; then
  error "git not found. Install Xcode Command Line Tools and re-run."
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
