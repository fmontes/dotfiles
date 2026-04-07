# ─── Git ────────────────────────────────────────────────────────────────────
alias g="git"
alias gs="git status"
alias ga="git add"
alias gaa="git add ."
alias gcm="git commit -m"
alias gp="git push"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gbd="git branch -d"
alias gl="git log --oneline --graph --decorate -20"
alias gll="git log --oneline --graph --decorate --all"

gcleanbranches() {
  git fetch -p
  git branch -vv | grep ': gone]' | awk '{print $1}' | xargs git branch -d
}

# ─── CLI Replacements ───────────────────────────────────────────────────────
alias cat="bat"
alias curl="curlie"
alias f="fd"

# ─── Ports ──────────────────────────────────────────────────────────────────
port() {
  local process
  process=$(lsof -i ":$1" | grep LISTEN)
  echo "$process"
}

killport() {
  local pid
  pid=$(lsof -ti ":$1")
  if [[ -z "$pid" ]]; then
    echo "Nothing listening on port $1"
    return
  fi
  echo "Killing PID $pid on port $1"
  echo "$pid" | xargs kill -9
}

ports() {
  echo "── Host processes ──"
  lsof -i -P | grep LISTEN | grep -E 'node|bun|deno|java|ruby'
  echo "── Docker containers ──"
  docker ps --format "{{.Names}}\t{{.Ports}}" 2>/dev/null | while IFS=$'\t' read -r name ports; do
    local mapped=$(echo "$ports" | grep -oE '0\.0\.0\.0:[0-9]+->[0-9]+/tcp' | sed 's/0.0.0.0://' | sed 's|->| -> |')
    [[ -n "$mapped" ]] && echo "$name: $mapped"
  done
}
alias devports='lsof -i :3000,3001,4200,5173,8080,8090,8443 | grep LISTEN'

killdev() {
  lsof -ti:3000,3001,4200,5173,8080,8443 | xargs kill -9 2>/dev/null
  echo "Killed common dev ports"
}

# ─── Projects ───────────────────────────────────────────────────────────────
proj() {
  local dir
  dir=$(zoxide query -l | fzf --preview 'ls {}')
  [[ -n "$dir" ]] && cd "$dir" && cursor --new-window .
}

# ─── GitHub ─────────────────────────────────────────────────────────────────
alias prs="gh dash"

# ─── Dotfiles ───────────────────────────────────────────────────────────────
dotfiles() { cursor --new-window ~/Developer/dotfiles }
alias zreload="source ~/.zshrc && echo 'Reloaded'"

# ─── Claude / cmux ──────────────────────────────────────────────────────────
alias claude-teams="cmux claude-teams"
alias ct="cmux claude-teams"
alias ct-continue="cmux claude-teams --continue"

# ─── Help ───────────────────────────────────────────────────────────────────
aliases() { bat ~/.config/zsh/aliases.zsh }

# ─── Misc ───────────────────────────────────────────────────────────────────
alias run-help=man
alias cursor="cursor --new-window"
