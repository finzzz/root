export PATH="/home/f/.local/bin:$PATH"
export PATH="/home/linuxbrew/.linuxbrew/opt/rustup/bin:$PATH"

export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="af-magic"
export EDITOR='nvim'

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

alias ls="eza"
alias cd="z"
alias bazel="bazelisk"
alias lg="lazygit"
alias vi="nvim"
alias dea="direnv allow"
alias ga="git add"
alias gcm="git commit -m"
alias gca="git commit --amend"
alias gcp="git cherry-pick"
alias gst="git stash"
alias gs="git status -sb"
alias gco="git checkout"
alias grb="git rebase"
alias gp="git push"
alias gw="git worktree"
alias tf="tofu"
alias tfe="tofuenv"

# somehow tmux doesn't recognize HOME END key
bindkey "^[OH" beginning-of-line
bindkey "^[OF" end-of-line
