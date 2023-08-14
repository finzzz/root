## finzzz's dotfiles

### brew

```bash
brew bundle install --file=Brewfile-cli
brew bundle install --file=Brewfile-gui

export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin # linux
export PATH=$PATH:/opt/homebrew/bin              # mac
```

### fish shell

```bash
sudo chsh -s $(which fish) $USER                                       # set default shell
git clone https://github.com/PatrickF1/fzf.fish $HOME/.config/fzf.fish # clone fzf.fish
touch $HOME/.fish_custom                                               # custom fish settings
ln -s $(readlink -f .fish_profile) $HOME/
```

### nvim

```bash
git clone --depth 1 https://github.com/AstroNvim/AstroNvim $HOME/.config/nvim
ln -s $(readlink -f .config/nvim/lua/user) $HOME/.config/nvim/lua/user
```

### .config

```fish
for i in .config/*
  ln -s $(readlink -f $i) $HOME/.config
end
```

### others

```bash
ln -s $(readlink -f .gitconfig) $HOME/
ln -s $(readlink -f .tmux.conf) $HOME/
ln -s $(readlink -f starship.toml) $HOME/
```
