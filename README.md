# .dotfiles

i am making this repo mostly for myself, to synchronize my workflow across different machines and clusters. so this doc will have minimum of explanation `¯\_(ツ)_/¯`

if you got questions -- add an issue. 

```sh
git clone https://github.com/haykh/.dotfiles.git ~/.dotfiles
```

## basics 

### `alacritty`
linking `alacritty` conf file (requires `MesloLGS NF` font pack, included in `fonts/` dir).
```sh
ln -s ~/.dotfiles/.config/alacritty ~/.config
```

### `zsh`
`zsh` uses [`oh-my-zsh`](https://ohmyz.sh/) and [`p10k`](https://github.com/romkatv/powerlevel10k#oh-my-zsh).
```sh
# ~/.zshrc
. ~/.dotfiles/.zshrc

# ~/.p10k.zsh
. ~/.dotfiles/.p10k.zsh
```

### `vim`
`vim` uses [`vundle`](https://github.com/VundleVim/Vundle.vim#quick-start).
```sh
# ~/.vimrc
source ~/.dotfiles/.vimrc
```

### `ssh`
```sh
# ~/.ssh/config
Include ~/.dotfiles/.ssh/config
```

## the looks

### `colorls`
i also use [`colorls`](https://github.com/athityakumar/colorls#installation) (requires `ruby`).
```sh
ln -s ~/.dotfiles/.config/colorls ~/.config

# ~/.zshrc
alias ls='colorls --sd'
```

### `i3`
```sh
ln -s ~/.dotfiles/.config/i3/config ~/.config/i3/config
```

### `polybar`
```sh
ln -s ~/.dotfiles/.config/polybar ~/.config
```

### `picom`
```sh
git clone https://github.com/yshui/picom.git
sudo apt install libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev
cd picom
git submodule update --init --recursive
meson --buildtype=release . build
meson configure -Dprefix=~/.local build
ninja -C build
ninja -C build install
ln -s ~/.dotfiles/.config/picom/picom.conf ~/.config/picom.conf
```

## work

### `latex`
```sh
ln -s ~/.dotfiles/.latexmkrc ~/.latexmkrc
```

everything here is compiled and installed locally (either `/usr/local/` or `$HOME/.local/` or something similar).

## `python`

```sh
git clone https://github.com/python/cpython
cd cpython
git checkout <PYTHON_VERSION>
./configure --enable-optimizations --prefix=<PATH_TO>/.local/
make -s -j<NCORES>
make install
```

## `pip` and `virtualenv`

make sure `<PATH_TO>/.local` is in the `PATH` and check `which python` to ensure the correct python is being used.

```sh
python -m ensurepip
which pip
# make sure the correct `pip` is used
pip install virtualenv
pip install virtualenvwrapper 
echo "export WORKON_HOME=~/<VENV_PATH>" >> ~/.zshrc
echo "source <PATH_TO>/.local/bin/virtualenvwrapper.sh" >> ~/.zshrc
source ~/.zshrc
mkvirtualenv <PYTHON_ENV>
```

## `nodejs`

for node source see [here](https://nodejs.org/dist/v14.17.0/node-v14.17.0.tar.gz).

```sh
wget <URL_NODE_SOURCE>.tar.gz
tar -xvf <NODE_SOURCE>.tar.gz
cd <NODE_SOURCE>
./configure --prefix=<PATH_TO>/.local
make -j<NCORES>
make install
```

## `vtk`

```sh
git clone https://gitlab.kitware.com/vtk/vtk.git
cd vtk
cmake -DCMAKE_INSTALL_PREFIX=<PATH_TO>/.local/ -B build .
cd build
make -j<NCORES>
make install
```

