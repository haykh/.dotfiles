# hardware

## enable hibernation
```sh
# ensure that swap partition exists
sudo vim /etc/mkinitcpio.conf
# add `resume` in HOOKS (between `filesystem` and `fsck`)
# regenerate `initramfs`
sudo mkinitcpio -P
sudo echo "HibernateMode=shutdown" >> /etc/systemd/sleep.conf
```

## disable accidental wake on keyboard tap
```sh
sudo echo ACTION==\"add\", SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"32ac\", ATTRS{idProduct}==\"0012\", ATTR{power/wakeup}=\"disabled\" >> /etc/udev/rules.d/90-disable-keyboard-wake.rules
sudo udevadm control --reload
sudo udevadm trigger
```

## icc profile
```sh
yay -S xiccd
sudo cp $HOME/.dotfiles/.config/framework16.icm /usr/share/color/icc/colord/
sudo systemctl enable colord.service
sudo systemctl restart colord.service
# first shell
xiccd
# second shell
colormgr get-profiles # (note profile id)
colormgr get-devices # (note device id)
colormgr device-add-profile DEVICE_ID PROFILE_ID
colormgr device-make-profile-default DEVICE_ID PROFILE_ID
```

## ignore power key
```sh
sudo echo "HandlePowerKey=ignore" >> /etc/systemd/logind.conf
```

## battery & fan control
```sh
yay -S fw-ectool-git
# auto fan control:
sudo ectool --interface=lpc autofanctrl
# set charge limit to 85%:
sudo ectool fwchargelimit 85
# start charging when the battery is below 2% and stop charging when it reaches 85%:
sudo ectool chargecontrol normal 2 85
# to reset `sudo ectool chargecontrol normal`
```

## utils
```sh
sudo pacman -S power-profiles-daemon
sudo systemctl enable power-profiles-daemon.service

sudo pacman -S wev
```

## sound, bluetooth, wireless
```sh
# sound
sudo pacman -S pipewire-media-session pipewire-jack pipewire-pulse pipewire-alsa pulsemixer

# wireless
sudo pacman -S iwd network-manager
sudo pacman -S wireless-regdb
sudo nvim /etc/conf.d/wireless-regdom
# uncomment WIRELESS_REGDOM="US"

# bluetooth
sudo pacman -S bluez bluez-utils bluetuith
```

# visuals

## compositor, display server, desktop portal, etc.
```sh
sudo pacman -S hyprland wayland hyprpaper hyprlock xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
yay -S hyprpicker
ln -s $HOME/.dotfiles/.config/hypr/ $HOME/.config/hypr
sudo pacman -S dunst
ln -s $HOME/.dotfiles/.config/dunst/ $HOME/.config/dunst
```

## gtk theme
```sh
sudo pacman -S sassc gnome-themes-extra gtk-engine-murrine nwg-look
yay -S awf-gtk4 awf-gtk3
cd $HOME/.dotfiles/.themes/Orchis
./install.sh -c dark -s standard -i arch --round 5px --tweaks primary -t purple
wget https://github.com/EliverLara/candy-icons/archive/refs/heads/master.zip
unzip master.zip -c $HOME/.local/share/icons/
# and change gtk & icon themes
nwg-look
```

## desktop manager
```sh
sudo pacman -S lemurs
sudo systemctl disable display-manager.service
sudo systemctl enable lemurs.service
sudo cp $HOME/.dotfiles/.config/lemurs/hypr /etc/lemurs/wayland/hypr
sudo chmod 755 /etc/lemurs/wayland/hypr
sed -i 's/ExecStart\=\/usr\/bin\/lemurs/ExecStart=\/usr\/bin\/lemurs -c \/home\/hayk\/.dotfiles\/.config\/lemurs\/config.toml/' /usr/lib/systemd/system/lemurs.service
```

## logout manager & bar
```sh
sudo pacman -S wlogout
ln -s $HOME/.dotfiles/.config/wlogout/ $HOME/.config/wlogout

ln -s $HOME/.dotfiles/scripts/wlprop $HOME/.local/bin/wlprop

sudo pacman -S waybar
ln -s $HOME/.dotfiles/.config/waybar/ $HOME/.config/waybar
```

# utils

```sh
ln -s $HOME/.dotfiles/.config/electron-flags.conf $HOME/.config/electron-flags.conf

sudo pacman -S thunar

sudo pacman -S playerctl
mkdir -p $HOME/.config/systemd/user/
cp $HOME/.dotfiles/.config/systemd/playerctld.service $HOME/.config/systemd/user/
systemctl daemon-reload
systemctl enable --user playerctld.service --now

yay -S spotify
ln -s $HOME/.dotfiles/.config/spotify-flags.conf $HOME/.config/spotify-flags.conf

curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
spicetify backup apply
cd $HOME/.themes
git clone --depth=1 https://github.com/spicetify/spicetify-themes.git /tmp/spicetify-themes
cd /tmp/spicetify-themes
cp -r * $HOME/.config/spicetify/Themes

# extra
sudo pacman -S w3m usbutils imv mpv
ln -s $HOME/.dotfiles/.config/imv/ ~/.config/imv
ln -s $HOME/.dotfiles/.config/mpv/ ~/.config/mpv

wget https://github.com/Alex313031/thorium/releases/download/.../thorium-browser_..._AVX2.zip
unzip thorium-browser_124.0.6367.218_AVX2.zip -d .
mv thorium $HOME/.local/thorium.app
ln -s $HOME/.dotfiles/.config/chrome-flags.conf ~/.config

# desktop apps
ln -s $HOME/.dotfiles/desktopapps/* $HOME/.local/share/applications/
```

# dev

```sh
sudo pacman -S neovim

# python
sudo pacman -S python python-virtualenv python-pipx

# vscode
yay -S vscodium-bin-marketplace
```

# firefox
https://github.com/Naezr/ShyFox
```sh
# about:config
shyfox.remove.window.controls = true
shyfox.disable.floating.search = true
shyfox.enable.ext.mono.context.icons = true
shyfox.enable.ext.mono.toolbar.icons = true
shyfox.enable.context.menu.icons = true
```

TODO:

- [x] waybar
  - [x] weather
  - [x] media
  - [x] groups
- [x] thunar
- [x] rofi
- [x] power management: https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Changing_suspend_method
- [ ] plugins
- [x] notifications
- [x] brightness & volume indicators
