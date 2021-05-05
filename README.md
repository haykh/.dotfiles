# .dotfiles

i am making this repo mostly for myself, to synchronize my workflow across different machines and clusters. so this doc will have minimum of explanation `¯\_(ツ)_/¯`

if you got questions -- add an issue. 

```shell
$ git clone https://github.com/haykh/.dotfiles.git ~/.dotfiles
```

linking `alacritty` conf file (requires `MesloLGS NF` font pack, included in `fonts/` dir).
```shell
$ mkdir -p ~/.config/alacritty
$ ln -s ~/.dotfiles/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
```

`zsh` uses [`oh-my-zsh`](https://ohmyz.sh/) and [`p10k`](https://github.com/romkatv/powerlevel10k#oh-my-zsh).
```shell
# ~/.zshrc
. ~/.dotfiles/.zshrc

# ~/.p10k.zsh
. ~/.dotfiles/.p10k.zsh
```

`vim` uses [`vundle`](https://github.com/VundleVim/Vundle.vim#quick-start).
```shell
# ~/.vimrc
source ~/.dotfiles/.vimrc
```

```shell
# ~/.ssh/config
Include ~/.dotfiles/.ssh/config
```

i also use [`colorls`](https://github.com/athityakumar/colorls#installation) (requires `ruby`).
```shell
$ mkdir -p ~/.config/colorls
$ ln -s ~/.dotfiles/.config/colorls/dark_colors.yaml ~/.config/colorls/dark_colors.yaml
$ ln -s ~/.dotfiles/.config/colorls/files.yaml ~/.config/colorls/files.yaml
$ ln -s ~/.dotfiles/.config/colorls/folders.yaml ~/.config/colorls/folders.yaml

# ~/.zshrc
alias ls='colorls --sd'
```
