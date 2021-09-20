## compilation procedure for some of the software

<!--
i3
ln -s ~/.dotfiles/.config/i3/config ~/.config/i3/config
polybar
ln -s ~/.dotfiles/.config/polybar ~/.config
picom
ln -s $HOME/.dotfiles/.config/picom/picom.conf $HOME/.config/picom/picom.conf
-->


### `vim`
```shell
git clone https://github.com/vim/vim
cd vim
./configure --prefix=$HOME/.local/ --with-features=huge --enable-multibyte --enable-cscope --enable-luainterp --enable-pythoninterp --enable-rubyinterp --enable-python3interp
make -j `nproc`
make install
```

### `picom`
```sh
git clone https://github.com/yshui/picom.git
sudo apt install libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-xinerama0-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl1-mesa-dev libpcre2-dev libpcre3-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev
cd picom
git submodule update --init --recursive
meson --buildtype=release . build
meson configure -Dprefix=$HOME/.local build
ninja -C build
ninja -C build install
```

### `python`
```sh
git clone https://github.com/python/cpython
cd cpython
git checkout <PYTHON_VERSION>
./configure --enable-optimizations --prefix=$HOME/.local/
make -s -j `nproc`
make install
```

### `nodejs`
for node source see [here](https://nodejs.org/en/download/).

```sh
wget <URL_NODE_SOURCE>.tar.gz
tar -xvf <NODE_SOURCE>.tar.gz
cd <NODE_SOURCE>
./configure --prefix=$HOME/.local
make -j `nproc`
make install
```

### `vtk`

```sh
git clone https://gitlab.kitware.com/vtk/vtk.git
cd vtk
cmake -DCMAKE_INSTALL_PREFIX=$HOME/.local/ -B build .
cd build
make -j `nproc`
make install
```
