# ─── Homebrew ───────────────────────────────────────────────────────────────
eval "$(/opt/homebrew/bin/brew shellenv)"

# ─── Oh My Zsh ──────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=()
fpath+=("/opt/homebrew/share/zsh/site-functions")
source $ZSH/oh-my-zsh.sh

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

# mise (replaces nvm, pyenv, sdkman)
export MISE_TRUSTED_CONFIG_PATHS="$HOME/Developer"
eval "$(mise activate zsh)"

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

# atuin (shell history)
eval "$(atuin init zsh)"

# zsh-autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# zsh-syntax-highlighting (must be last before starship)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Starship prompt (must be last)
eval "$(starship init zsh)"
