# .dotfiles

i am making this repo mostly for myself, to synchronize my workflow across different machines and clusters. so this doc will have minimum of explanation `¯\_(ツ)_/¯`

if you got questions -- add an issue. 

```shell
$ git clone https://github.com/haykh/.dotfiles.git ~/.dotfiles
```
### `alacritty`
linking `alacritty` conf file (requires `MesloLGS NF` font pack, included in `fonts/` dir).
```shell
$ ln -s ~/.dotfiles/.config/alacritty ~/.config
```

### `zsh`
`zsh` uses [`oh-my-zsh`](https://ohmyz.sh/) and [`p10k`](https://github.com/romkatv/powerlevel10k#oh-my-zsh).
```shell
# ~/.zshrc
. ~/.dotfiles/.zshrc

# ~/.p10k.zsh
. ~/.dotfiles/.p10k.zsh
```

### `vim`
`vim` uses [`vundle`](https://github.com/VundleVim/Vundle.vim#quick-start).
```shell
# ~/.vimrc
source ~/.dotfiles/.vimrc
```

### `ssh`
```shell
# ~/.ssh/config
Include ~/.dotfiles/.ssh/config
```

### `colorls`
i also use [`colorls`](https://github.com/athityakumar/colorls#installation) (requires `ruby`).
```shell
$ ln -s ~/.dotfiles/.config/colorls ~/.config

# ~/.zshrc
alias ls='colorls --sd'
```

### `polybar`
```shell
$ ln -s ~/.dotfiles/.config/polybar ~/.config
```

### `latex`
```shell
$ ln -s ~/.dotfiles/.latexmkrc ~/.latexmkrc
```
