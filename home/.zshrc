# ─── Homebrew ───────────────────────────────────────────────────────────────
eval "$(/opt/homebrew/bin/brew shellenv)"

# ─── Oh My Zsh ──────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=()
fpath+=("/opt/homebrew/share/zsh/site-functions")
source $ZSH/oh-my-zsh.sh

# ─── Completions ────────────────────────────────────────────────────────────
# Tab-complete *remote* paths for scp/ssh (`scp f.zip mac2:/var/ww<TAB>`). zsh
# shells out to ssh to list the remote dir, so the host must log in without a
# prompt — key in the agent, `BatchMode=yes` clean. _remote_files reads this
# zstyle with `zstyle -T`, so remote access is already on unless something sets
# it to false; the line is here to say so out loud and to survive a plugin that
# turns it off. The speed comes from the `Host *` ControlMaster block in
# ~/.ssh/config (not committed): without multiplexing every Tab pays for a
# fresh TCP + auth handshake.
zstyle ':completion:*' remote-access yes

# ─── Editor ─────────────────────────────────────────────────────────────────
export EDITOR="nano"
export VISUAL="nano"

# ─── Environment ────────────────────────────────────────────────────────────
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=$(which chromium)

export PNPM_HOME="$HOME/Library/pnpm"
export BUN_INSTALL="$HOME/.bun"
export DOCKER_HOST=unix:///var/run/docker.sock

# ─── PATH ───────────────────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"   # claude and other native-installer bins
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
export PATH="$PATH:$HOME/.cache/lm-studio/bin"
export PATH="~/.console-ninja/.bin:$PATH"

# ─── Tool Loaders ───────────────────────────────────────────────────────────
# Cargo
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# Docker
source "$HOME/.docker/init-zsh.sh" 2>/dev/null || true

# mise (replaces nvm, pyenv, sdkman)
# Auto-trust mise configs under these roots, so a fresh clone does not need a
# manual `mise trust`. Note this trusts any .mise.toml found there, including
# in repos cloned from elsewhere — mise configs can set env vars and run hooks.
export MISE_TRUSTED_CONFIG_PATHS="$HOME/Developer:$HOME/orca"
eval "$(mise activate zsh)"

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || true

# ─── Aliases ────────────────────────────────────────────────────────────────
for f in ~/.config/zsh/*.zsh; do source "$f"; done

# ─── Tools ──────────────────────────────────────────────────────────────────
# fzf
eval "$(fzf --zsh)"

# zoxide (replaces cd)
eval "$(zoxide init zsh)"

# atuin (shell history)
eval "$(atuin init zsh)"

# zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting (must be last before starship)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Starship prompt (must be last)
eval "$(starship init zsh)"

# try-cli (tobi/try) — ephemeral workspace manager
#
# Both halves must name the *binary*, not the function. The eval below defines a
# shell function called `try`, so on a re-source that function shadows the
# binary: `try init ~/src/tries` then reaches try.rb as `exec ... init`, which
# reads `init` as a search query and opens the interactive selector instead of
# printing anything. `command -v try` finds the function too, so it is no guard.
# `whence -p` searches only $PATH, and `command try` skips the function.
whence -p try &>/dev/null && eval "$(command try init ~/src/tries)"

# direnv hook
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"
