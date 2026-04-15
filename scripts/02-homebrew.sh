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

echo "Installing packages from Brewfile..."
brew bundle --file="$DOTFILES_DIR/Brewfile"
