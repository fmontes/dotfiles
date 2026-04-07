# ─── Homebrew ───────────────────────────────────────────────────────────────
eval "$(/opt/homebrew/bin/brew shellenv)"

# ─── Oh My Zsh ──────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)
fpath+=("/opt/homebrew/share/zsh/site-functions")
source $ZSH/oh-my-zsh.sh

# Pure prompt
autoload -U promptinit; promptinit
prompt pure

# ─── Environment ────────────────────────────────────────────────────────────
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PUPPETEER_EXECUTABLE_PATH=$(which chromium)

export PNPM_HOME="$HOME/Library/pnpm"
export SDKMAN_DIR="$HOME/.sdkman"
export BUN_INSTALL="$HOME/.bun"
export DOCKER_HOST=unix:///var/run/docker.sock

# ─── PATH ───────────────────────────────────────────────────────────────────
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
. "$HOME/.cargo/env"
. "$HOME/.local/bin/env"

# Docker
source "$HOME/.docker/init-zsh.sh" 2>/dev/null || true

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# SDKMAN
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# OrbStack
source ~/.orbstack/shell/init.zsh 2>/dev/null || true

# cmux (Ghostty shell integration)
if [[ -n "$TERM_PROGRAM" && "$TERM_PROGRAM" == "ghostty" ]]; then
  source /Applications/cmux.app/Contents/Resources/shell-integration/cmux-zsh-integration.zsh 2>/dev/null || true
fi

# ─── Aliases ────────────────────────────────────────────────────────────────
for f in ~/.config/zsh/*.zsh; do source "$f"; done

# ─── Tools ──────────────────────────────────────────────────────────────────
# fzf
eval "$(fzf --zsh)"

# zoxide (replaces cd)
eval "$(zoxide init zsh)"

# zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting (must be last)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
