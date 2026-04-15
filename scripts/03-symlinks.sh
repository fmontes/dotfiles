#!/usr/bin/env zsh
DOTFILES_HOME="$DOTFILES_DIR/home"

create_symlink() {
  local src="$1"
  local dest="$2"

  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    echo "  [skip]    $dest"
  elif [[ -f "$dest" ]]; then
    echo "  [backup]  $dest -> ${dest}.bak"
    mv "$dest" "${dest}.bak"
    ln -sf "$src" "$dest"
    echo "  [linked]  $dest"
  else
    ln -sf "$src" "$dest"
    echo "  [linked]  $dest"
  fi
}

while IFS= read -r -d '' file; do
  rel="${file#$DOTFILES_HOME/}"
  # Skip paths handled by directory symlinks below
  [[ "$rel" == .config/helix/* ]] && continue
  dest="$HOME/$rel"
  create_symlink "$file" "$dest"
done < <(find "$DOTFILES_HOME" -type f -print0)

# Directory symlinks (whole directories, not individual files)
if [[ -L "$HOME/.config/helix" ]]; then
  echo "  [skip]    ~/.config/helix"
else
  [[ -d "$HOME/.config/helix" && ! -L "$HOME/.config/helix" ]] && mv "$HOME/.config/helix" "$HOME/.config/helix.bak"
  mkdir -p "$HOME/.config"
  ln -sf "$DOTFILES_HOME/.config/helix" "$HOME/.config/helix"
  echo "  [linked]  ~/.config/helix"
fi

echo "Symlinks created."
