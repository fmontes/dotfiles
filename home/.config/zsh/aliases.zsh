# ─── Git ────────────────────────────────────────────────────────────────────
alias g="git"
alias gco="git checkout"
alias gs="git status"
alias ga="git add"
alias gaa="git add ."
alias gcm="git commit -m"
alias gp="git push"

# ─── Tools ──────────────────────────────────────────────────────────────────
alias cat="bat"
alias curl="curlie"
alias find="fd"

# ─── Node ───────────────────────────────────────────────────────────────────
alias node-update="nvm install --lts && nvm alias default lts/*"

# Show what's running on a port: port 3000
port() { lsof -i ":$1" | grep LISTEN }

# Kill whatever is running on a port: killport 3000
killport() { lsof -ti ":$1" | xargs kill -9 }

# List all active node/js ports
ports() { lsof -i -P | grep LISTEN | grep -E 'node|bun|deno' }

# ─── GitHub ─────────────────────────────────────────────────────────────────
alias prs="gh dash"

# ─── Claude Code ────────────────────────────────────────────────────────────
alias claude-teams="cmux claude-teams"
alias ct="cmux claude-teams"
alias ct-continue="cmux claude-teams --continue"

# ─── Misc ───────────────────────────────────────────────────────────────────
alias run-help=man
alias cursor="cursor --new-window"
alias toto="open vnc://toto@toto"
alias totossh="ssh toto@toto"
