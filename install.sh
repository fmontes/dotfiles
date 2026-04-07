#!/usr/bin/env zsh
set -e

DOTFILES_DIR="$(cd "$(dirname "${(%):-%x}")" && pwd)"
export DOTFILES_DIR

info()  { echo "\033[0;32m==>\033[0m $1"; }
error() { echo "\033[0;31m==>\033[0m $1"; exit 1; }

run_script() {
  local script="$DOTFILES_DIR/scripts/$1"
  [[ -f "$script" ]] || error "Script not found: $script"
  info "Running $1..."
  zsh "$script"
}

info "Starting dotfiles bootstrap for $(whoami)..."

run_script 01-xcode.sh
run_script 02-homebrew.sh
run_script 03-symlinks.sh
run_script 04-omz.sh
run_script 05-mise.sh
run_script 06-macos.sh
run_script 07-post-install.sh

info "Done. Restart your terminal."
