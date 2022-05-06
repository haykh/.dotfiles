# .dotfiles

i am making this repo mostly for myself, to synchronize my workflow across different machines and clusters. so this doc will have minimum of explanation `¯\_(ツ)_/¯`.

there are also some building/installation instructions for some of the apps for ubuntu-based (`ubuntu`, `pop!_os`, `mint`) systems with `apt` package manager.

if you got questions -- add an issue.

```sh
git clone git@github.com:haykh/.dotfiles.git $HOME/.dotfiles
```

## build/install tools
```sh
sudo apt update
sudo apt install cmake pkg-config apt-file ruby-full rbenv curl
sudo apt install python3 python3-pip
sudo apt install ffmpeg ripgrep fd-find
sudo apt-file update
curl https://sh.rustup.rs -sSf | sh
mkdir -p $HOME/.local
sudo chown -R $USER:$USER $HOME/.local
```

## ssh
```sh
sudo apt install ssh
mkdir $HOME/.ssh
mkdir $HOME/.ssh/sockets

echo "Include ~/.dotfiles/.ssh/config" >> $HOME/.ssh/config
```

## turbovnc
[link](https://sourceforge.net/projects/turbovnc/files/)
```sh
# wget from website
# install using `sudo apt install ./....deb`
# installed in `/opt/TurboVNC`
sudo apt install default-jre
```

## alacritty
```sh
sudo apt install libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev
git clone https://github.com/alacritty/alacritty.git
cd alacritty
cargo build --release
sudo cp target/release/alacritty $HOME/.local/bin/
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator `which alacritty` 50
sudo update-alternatives --config x-terminal-emulator
ln -s $HOME/.dotfiles/.config/alacritty $HOME/.config
```

## fonts
```sh
mkdir $HOME/.fonts
cp -r $HOME/.dotfiles/fonts/* $HOME/.fonts
sudo apt install fonts-powerline
fc-cache -rv
```

## zsh + oh-my-zsh + p10k
download [`chroma`](https://github.com/alecthomas/chroma/releases) binary and move to `$HOME/.local/bin`.
```sh
sudo apt install zsh
sudo chsh -s `which zsh` $USER
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
touch $HOME/.zshrc
echo ". $HOME/.dotfiles/.zshrc" >> $HOME/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
touch $HOME/.p10k.zsh
echo ". $HOME/.dotfiles/.p10k.zsh" >> $HOME/.p10k.zsh
echo "export PATH=$PATH:$HOME/.cargo/bin" >> $HOME/.zshrc
```

### some zsh_functions

```sh
# add all, commit (with comment) and push to git
gitall <COMMENT>
# make a movie from a series of pngs (`-h` for help)
makemovie -h
# search a regex match recursively in the current directory
srch <REGEX>
# record screen with ffmpeg and save to file (`-h` for help)
screencast -h
```

## exa

```sh
cargo install exa
```

## nvim
Download `.deb` package from [nvim](https://github.com/neovim/neovim/releases/tag/v0.7.0).
```sh
sudo apt install ./nvim-linux64.deb
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
ln -s $HOME/.dotfiles/.config/nvim $HOME/.config/nvim
nvim +PlugInstall
```
Useful links:
- clipboard on `wsl` [nvim faq](https://github.com/neovim/neovim/wiki/FAQ#how-to-use-the-windows-clipboard-from-wsl)

## python
```sh
pip3 install virtualenv --user
pip3 install virtualenvwrapper --user
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> $HOME/.zshrc
echo "export WORKON_HOME=$HOME/.local/pyvenv" >> $HOME/.zshrc
echo "source $HOME/.local/bin/virtualenvwrapper.sh" >> $HOME/.zshrc
source $HOME/.zshrc
```

## brave browser
[link](https://brave.com/linux/#linux)
```sh
sudo apt install apt-transport-https
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser
```

## latex
[link](https://www.tug.org/texlive/acquire-netinstall.html)
```sh
wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
# install using `./install-tl`
ln -s $HOME/.dotfiles/.latexmkrc $HOME/.latexmkrc
```
