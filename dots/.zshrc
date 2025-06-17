BREW_PATH="/opt/homebrew"
if [[ "$(uname)" != "Darwin" ]]; then
  BREW_PATH="/home/linuxbrew/.linuxbrew"
fi

export PATH="$HOME/.local/bin:$PATH"
export PATH="$BREW_PATH/bin:$PATH"
export PATH="/opt/rustup/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export PATH="$BREW_PATH/opt/ruby/bin:$PATH"
export PATH="$BREW_PATH/opt/cocoapods/bin:$PATH"
export PATH="$BREW_PATH/opt/ansible@10/bin:$PATH"
export PATH="$HOME/.bun/bin:$PATH"

export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="af-magic"
export EDITOR='nvim'
export TF_PLUGIN_CACHE_DIR="$HOME/.tf_plugin_cache"
export DISABLE_TELEMETRY=true
export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"

# https://github.com/ohmyzsh/ohmyzsh/wiki/plugins
plugins=(
  # argocd
  aws
  # bazel
  brew
  direnv
  docker
  eza
  fzf
  gh
  git
  golang
  helm
  istioctl
  kubectl
  rust
  ssh
  ssh-agent
  starship
  tailscale
  # terraform
  zoxide
)

source $ZSH/oh-my-zsh.sh
command -v k0sctl 2>&1 >/dev/null && . <(k0sctl completion)
command -v wmill 2>&1 >/dev/null && . <(wmill completions zsh)
command -v atuin 2>&1 >/dev/null && . <(atuin init zsh --disable-up-arrow)

alias awsp='export AWS_PROFILE=$(sed -n "s/\[profile \(.*\)\]/\1/gp" ~/.aws/config | fzf)'
alias bazel="bazelisk"
alias bzgo="bazel run @rules_go//go --"
alias bzpnpm="bazel run @pnpm//:pnpm --"
alias bzm="bazel mod"
alias cd="z"
alias code="code-server"
alias dea="direnv allow"
alias ft="flutter"
alias ga="git add"
alias gca="git commit --amend"
alias gcm="git commit -m"
alias gco="git checkout"
alias gcp="git cherry-pick"
alias gp="git push"
alias grb="git rebase"
alias grep='grep --color=auto'
alias gs="git status -sb"
alias gst="git stash"
alias gw="git worktree"
alias ip="ip -color"
alias k="kubectl"
alias k0="k0sctl"
alias kc="kubecm"
alias lg="lazygit"
alias ls="eza"
alias tc='talosctl'
alias tcc='tc config'
alias tcd='tc dashboard'
alias tcrs='tc read /system/state/config.yaml' # read system config state
alias tcs='tc stats'
alias tf="tofu"
alias tfe="tofuenv"
alias top='btop'
alias vi="nvim"
alias v="vultr"
alias watch="watch "
alias wget='wget -c'
alias ytl='yt-dlp -qF --list-formats' # <url>
alias ytd='yt-dlp -f' # <format id: 251+271> <url>

# somehow tmux doesn't recognize HOME END key
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line

[ ! -f "$HOME/user.zshrc" ] && touch $HOME/user.zshrc
source $HOME/user.zshrc

# wti https://github.com/f4z-dev/everything
wti() {
  DIRNAME=$(basename $1)
  mkdir $DIRNAME && cd $DIRNAME
  git clone --bare "$1" .bare
  echo "gitdir: ./.bare" > .git
  git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  git fetch origin
  cd -
}

# wta vince/test
wta() {
  DIRNAME=$(echo $1 | sed -e 's#/#:#')
  if [[ "$(git branch | grep -o $1)" == "$1" ]]; then
    git worktree add $DIRNAME $1
  else
    git worktree add $DIRNAME -b $1
  fi
  echo "gitdir: "$(realpath -s --relative-to=$DIRNAME $(rg -o '/.*' $DIRNAME/.git)) > $DIRNAME/.git
  cd $DIRNAME
}

unalias gup
gup() {
  INITBRANCH=$(git config --get init.defaultBranch)
  gf && grb "origin/$INITBRANCH"
}

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

dockb(){
  CONFIG="Dockerconfig.yaml"
  if [[ ! -f $CONFIG ]]; then
    echo "Dockertag file not found"
    return
  fi

  if [[ $(command -v yq >/dev/null) ]]; then
    echo "yq is required"
    return
  fi

  TAG="$(yq .tag $CONFIG)"
  PLATFORMS="$(yq '.platforms|join(",")' $CONFIG)"
  IS_PUSH=$(yq '.push == true' $CONFIG)

  PUSH=""
  if [[ $IS_PUSH == "true" ]]; then
    PUSH="--push"
  fi

  docker buildx build --platform "$PLATFORMS" -t "$TAG" $PUSH .
}

dockprune(){
  docker rm $(docker ps -a -f status=exited -f status=created -q)
}
