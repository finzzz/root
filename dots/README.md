## finzzz's dotfiles

```bash
brew bundle install --file=Brewfile
mkdir -p $HOME/.config/nvim

ln -s $(readlink -f .gitconfig) $HOME/
ln -s $(readlink -f .tmux.conf) $HOME/
ln -s $(readlink -f starship.toml) $HOME/
ln -s $(readlink -f .config/nvim/init.lua) $HOME/.config/nvim/

# mac
ln -s $(readlink -f .config/karabiner/karabiner.json) $HOME/.config/karabiner/
```
