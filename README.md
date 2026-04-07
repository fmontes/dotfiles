# dotfiles

My personal Mac setup. Clone and run `install.sh` to go from zero to a fully configured machine.

## What's included

- **Zsh** with Oh My Zsh, Pure prompt, autosuggestions, syntax highlighting
- **Homebrew** packages and casks via `Brewfile`
- **Aliases** split by context (git, dotCMS, misc)
- **macOS defaults** for Dock, Finder, keyboard
- **App list** for manual installs

## Bootstrap a new Mac

```bash
git clone https://github.com/fmontes/dotfiles ~/Developer/dotfiles
cd ~/Developer/dotfiles
zsh install.sh
```

The script will:

1. Install Xcode Command Line Tools
2. Install Homebrew and all packages from `Brewfile`
3. Symlink all dotfiles to `~/`
4. Install Oh My Zsh
5. Install nvm
6. Apply macOS defaults
7. Print a checklist of manual steps

## After running install.sh

- Install **1Password** and sign in first
- Copy `home/.npmrc.template` → `~/.npmrc` and fill in tokens from 1Password
- Generate SSH key: `ssh-keygen -t ed25519 -C "freddymontes@gmail.com"` and add to GitHub
- Run `gh auth login`
- Run `nvm install --lts`
- Run `gcloud init`
## Structure

```
dotfiles/
├── Brewfile                  # Homebrew packages and casks
├── install.sh                # Bootstrap entry point
├── scripts/                  # Individual setup steps
└── home/                     # Dotfiles (mirrored to ~/)
    ├── .zshrc
    ├── .gitconfig
    ├── .tmux.conf
    └── .config/
        └── zsh/
            └── aliases.zsh   # Git + misc aliases
```

## Keeping Brewfile up to date

```bash
brew bundle dump --brews --casks --force --file=~/Developer/dotfiles/Brewfile
```

Run this before committing whenever you install new tools.
