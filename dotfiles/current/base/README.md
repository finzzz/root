## finzzz's dotfiles

### brew

```bash
export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin # linux
export PATH=$PATH:/opt/homebrew/bin              # mac

brew bundle install --file=Brewfile-cli
brew bundle install --file=Brewfile-gui
```

### nvim

```bash
ln -s $(readlink -f .config/nvim/init.lua) $HOME/.config/nvim/

# Setup in nvim
# :TSInstall all
# :TSUpdate
```

### .config

```bash
for i in .config/* ; do
  ln -s $(readlink -f $i) $HOME/.config/
done
```

### others

```bash
ln -s $(readlink -f .gitconfig) $HOME/
ln -s $(readlink -f .tmux.conf) $HOME/
ln -s $(readlink -f starship.toml) $HOME/
```

### fish shell

```bash
sudo chsh -s $(which fish) $USER                                       # set default shell
git clone https://github.com/PatrickF1/fzf.fish $HOME/.config/fzf.fish # clone fzf.fish
touch $HOME/.fish_custom                                               # custom fish settings
ln -s $(readlink -f .fish_profile) $HOME/
```

