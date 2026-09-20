#!/usr/bin/env zsh
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/tty
else
  echo "Homebrew already installed."
fi

BREW_BIN="/opt/homebrew/bin/brew"
[[ -x "$BREW_BIN" ]] || BREW_BIN="/usr/local/bin/brew"
eval "$("$BREW_BIN" shellenv)"

ZPROFILE="$HOME/.zprofile"
if ! grep -q 'brew shellenv' "$ZPROFILE" 2>/dev/null; then
  echo "Adding brew shellenv to $ZPROFILE..."
  {
    echo ''
    echo "eval \"\$($BREW_BIN shellenv)\""
  } >> "$ZPROFILE"
fi

# Runnable on its own, not just via install.sh which exports DOTFILES_DIR.
: "${DOTFILES_DIR:="${0:a:h:h}"}"

# `brew bundle` reports a non-zero exit if ANY entry fails, and install.sh runs
# under `set -e` — so one bad cask used to abort the whole installer before
# symlinks, oh-my-zsh, mise and the macOS defaults ever ran. Report and carry on:
# a missing formula is worth a warning, not a dead bootstrap.
echo "Installing packages from Brewfile..."
if brew bundle --file="$DOTFILES_DIR/Brewfile"; then
  echo "Brewfile satisfied."
else
  echo ""
  echo "WARNING: some Brewfile entries failed to install. Unmet ones:"
  brew bundle check --verbose --file="$DOTFILES_DIR/Brewfile" 2>&1 | sed -n 's/^→ /  /p'
  echo ""
  echo "A cask fails here when its app was installed by hand: Homebrew will not"
  echo "overwrite an app it does not track. Hand it over with"
  echo "  brew install --cask --adopt <name>"
  echo "(--adopt only works as a flag; HOMEBREW_CASK_OPTS does not carry it.)"
  echo "Continuing with the rest of the install."
fi
