# .dotfiles

i am making this repo mostly for myself, to synchronize my workflow across different machines and clusters. so this doc will have minimum of explanation `¯\_(ツ)_/¯`. if you got questions -- add an issue.

### current list of tools used:
- terminal emulator:
    - [`kitty`](https://sw.kovidgoyal.net/kitty/)
- shell: 
    - `zsh`
    - [`oh-my-zsh`](https://ohmyz.sh/)
    - [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh)
    - [`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md#oh-my-zsh)
    - [`starship`](https://starship.rs/)
    - [`eza`](https://eza.rocks/)
    - [`bat`](https://github.com/sharkdp/bat)
    - [`fzf`](https://github.com/junegunn/fzf)
    - [`ripgrep`](https://github.com/BurntSushi/ripgrep)
- editor:
    - [`neovim`](https://neovim.io/)
    - [`lazy.nvim`](https://github.com/folke/lazy.nvim)
- file manager:
    - [`ranger`](https://github.com/ranger/ranger)
- media/readers:
    - [`mpv`](https://mpv.io/)
    - [`spotifyd`](https://spotifyd.rs/)
    - [`spotify-tui`](https://github.com/Rigellute/spotify-tui)
    - [`sioyek`](https://github.com/ahrm/sioyek)
- other:
    - [`nvm`](https://github.com/nvm-sh/nvm)
    - [`nb`](https://github.com/xwmx/nb)
    - [`navi`](https://github.com/denisidoro/navi)
    - [`tldr`](https://tldr.sh/)
    - [`btop`](https://github.com/aristocratos/btop)
    - [`topgrade`](https://github.com/topgrade-rs/topgrade)
    - [`fastfetch`](https://github.com/fastfetch-cli/fastfetch)

### linking `rc` files on `linux`
```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm -f $HOME/.zshrc
echo ". $HOME/.dotfiles/.zshrc" >> $HOME/.zshrc

mkdir -p $HOME/.ssh
mkdir -p $HOME/.ssh/sockets
echo "Include $HOME/.dotfiles/.ssh/config" >> $HOME/.ssh/config

ln -s $HOME/.dotfiles/.config/nvim $HOME/.config/nvim
ln -s $HOME/.dotfiles/.config/kitty $HOME/.config/kitty
ln -s $HOME/.dotfiles/.config/ranger $HOME/.config/ranger
ln -s $HOME/.dotfiles/.config/mpv $HOME/.config/mpv
ln -s $HOME/.dotfiles/.config/sioyek $HOME/.config/sioyek
mkdir -p $HOME/.config/spotify-tui
ln -s $HOME/.dotfiles/.config/spotify-tui/config.yml $HOME/.config/spotify-tui/config.yml

ln -s $HOME/.dotfiles/.config/.nbrc $HOME/.nbrc
nb remote set git@github.com:haykh/nb.git

git clone https://github.com/alexanderjeurissen/ranger_devicons.git $HOME/.dotfiles/.config/ranger/plugins/ranger_devicons

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

source $HOME/.zshrc
cd $DOTFILES/fonts && sh ./install.sh && fc-cache -rv
```
