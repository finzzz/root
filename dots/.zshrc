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
