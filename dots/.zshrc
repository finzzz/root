BREW_PATH="/home/linuxbrew/.linuxbrew"
if [[ "$(uname)" == "Darwin" ]]; then
  BREW_PATH="/opt/homebrew"
  export PATH="$BREW_PATH/opt/ruby/bin:$PATH"
  export PATH="$BREW_PATH/opt/cocoapods/bin:$PATH"
  export PATH="$BREW_PATH/opt/ansible@10/bin:$PATH"
  export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
  export DOCKER_DEFAULT_PLATFORM="linux/amd64" # orbstack
fi

export PATH="$HOME/.local/bin:$PATH"
export PATH="$BREW_PATH/bin:$PATH"
export PATH="/opt/rustup/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="af-magic"
export EDITOR='nvim'
export TF_PLUGIN_CACHE_DIR="$HOME/.tf_plugin_cache"
export DISABLE_TELEMETRY=true
export LG_CONFIG_FILE="$HOME/lazygit.yaml"

# https://github.com/ohmyzsh/ohmyzsh/wiki/plugins
plugins=(
  aws
  direnv
  eza
  fzf
  git
  ssh-agent
  starship
  zoxide
)

source $ZSH/oh-my-zsh.sh
command -v atuin 2>&1 >/dev/null && . <(atuin init zsh --disable-up-arrow)

alias awsp='export AWS_PROFILE=$(sed -n "s/\[profile \(.*\)\]/\1/gp" ~/.aws/config | fzf)'
alias bazel="bazelisk"
alias bz="bazel"
alias bzgo="bazel run @rules_go//go --"
alias bzpnpm="bazel run @pnpm//:pnpm --"
alias cd="z"
alias code="code-server"
alias dea="direnv allow"
alias ft="flutter"
alias ga="git add"
alias gc="git commit"
alias gcb="git branch --show-current"
alias gco="git checkout"
alias gf="git fetch"
alias gp="git push"
alias grb="git rebase"
alias ip="ip -color"
alias k="kubectl"
alias kc="kubecm"
alias lg="lazygit"
alias ls="eza"
alias tc='talosctl'
alias tf="tofu"
alias tfe="tofuenv"
alias top='btop'
alias vi="nvim"
alias watch="watch "
alias wget='wget -c'
alias ytl='yt-dlp -qF --list-formats' # <url>
alias ytd='yt-dlp -f' # <format id: 251+271> <url>

# somehow tmux doesn't recognize HOME END key
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line

[ ! -f "$HOME/user.zshrc" ] && touch $HOME/user.zshrc
source $HOME/user.zshrc

tun(){
  [[ $1 == "h" ]] && declare -f $0 && return
  HOST=$(echo $1 | awk -F":" '/:[0-9]+/ && !/]/ {print $1}')
  PORT=$(echo $1 | awk -F":" '/:[0-9]+/ && !/]/ {print $2}')

  [[ $HOST == "" ]] && HOST="localhost"
  [[ $PORT == "" ]] && PORT=$1

  case $2 in
    "locahost")
      ssh -R 80:$HOST:$PORT localhost.run ;;
    "serveo")
      ssh -R 80:$HOST:$PORT serveo.net ;;
    *)
      ssh -p 443 -R0:$HOST:$PORT a.pinggy.io ;;
  esac
}

glone() {
  LINK="$1"
  NAME="${2:-$(basename $LINK)}"
  git clone --bare $LINK $NAME
  cd $NAME
  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"

  MAIN_OR_MASTER=$(git branch | grep -o -m1 "\b\(master\|main\)\b")
  git worktree add ws/$MAIN_OR_MASTER
  cd ws/$MAIN_OR_MASTER
}

gswitch() {
  [[ $(git rev-parse --is-inside-work-tree) == "false" ]] && return

  INPUT_BRANCH="$1"
  WORKTREE_NAME=$INPUT_BRANCH

  [[ $INPUT_BRANCH =~ "/" ]] && WORKTREE_NAME="${WORKTREE_NAME//\//-}"

  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  [[ "$INPUT_BRANCH" == "$CURRENT_BRANCH" ]] && return # no need to switch

  TOP=$(git rev-parse --show-toplevel)

  MAIN_OR_MASTER=$(git show-ref --verify --quiet refs/heads/master && echo master || echo main)
  REF="${2:-$MAIN_OR_MASTER}"

  git worktree list --porcelain | grep -q refs/heads/$INPUT_BRANCH \
    || git worktree add -b $INPUT_BRANCH "$TOP/../$WORKTREE_NAME" $REF 2>/dev/null \
    || git worktree add "$TOP/../$WORKTREE_NAME" $INPUT_BRANCH 2>/dev/null

  cd "$TOP/../$WORKTREE_NAME"

  # handle conflicts
  # workspace will have same WORKTREE_NAME for branch a/b and a-b
  CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  if [[ "$INPUT_BRANCH" != "$CURRENT_BRANCH" ]]; then
    git checkout -b "$INPUT_BRANCH" 2>/dev/null \
    || git checkout "$INPUT_BRANCH"
  fi
}

gitmux(){
  case $1 in
    "rename")
      ROOT_DIR=$(basename $(git rev-parse --show-toplevel))
      CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
      tmux rename-window "$ROOT_DIR@$CURRENT_BRANCH" ;;
    *)
      declare -f $0 ;;
  esac
}

dockprune(){
  docker rm $(docker ps -a -f status=exited -f status=created -q)
}
