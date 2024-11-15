export PATH="/home/f/.local/bin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/rustup/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="af-magic"
export EDITOR='nvim'
export TF_PLUGIN_CACHE_DIR="$HOME/.tf_plugin_cache"

# https://github.com/ohmyzsh/ohmyzsh/wiki/plugins
plugins=(
  argocd
  aws
  bazel
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
  terraform
  zoxide
)

source $ZSH/oh-my-zsh.sh

alias awsp='export AWS_PROFILE=$(sed -n "s/\[profile \(.*\)\]/\1/gp" ~/.aws/config | fzf)'
alias bazel="bazelisk"
alias cd="z"
alias dea="direnv allow"
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

gcob() {
  gco -b "$1-$(date +%s)"
}
