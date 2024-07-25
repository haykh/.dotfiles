```sh
# enable hibernation
# ensure that swap partition exists
sudo vim /etc/mkinitcpio.conf
# add `resume` in HOOKS (between `filesystem` and `fsck`)
# regenerate `initramfs`
sudo mkinitcpio -P
sudo echo "HibernateMode=shutdown" >> /etc/systemd/sleep.conf

# disable accidental wake on keyboard tap
sudo echo ACTION==\"add\", SUBSYSTEM==\"usb\", ATTRS{idVendor}==\"32ac\", ATTRS{idProduct}==\"0012\", ATTR{power/wakeup}=\"disabled\" >> /etc/udev/rules.d/90-disable-keyboard-wake.rules
sudo udevadm control --reload
sudo udevadm trigger

# icc profile
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

# ignore power key
sudo echo "HandlePowerKey=ignore" >> /etc/systemd/logind.conf

# utils
sudo pacman -S power-profiles-daemon
sudo systemctl enable power-profiles-daemon.service

# fan & battery control
yay -S fw-ectool-git
# auto fan control:
sudo ectool --interface=lpc autofanctrl
# set charge limit to 85%:
sudo ectool fwchargelimit 85
# start charging when the battery is below 2% and stop charging when it reaches 85%:
sudo ectool chargecontrol normal 2 85
# to reset `sudo ectool chargecontrol normal`

# sound
sudo pacman -S pipewire-media-session pipewire-jack pipewire-pulse pipewire-alsa pulsemixer

# wireless
sudo pacman -S iwd network-manager
sudo pacman -S wireless-regdb
sudo nvim /etc/conf.d/wireless-regdom
# uncomment WIRELESS_REGDOM="US"

# bluetooth
sudo pacman -S bluez bluez-utils bluetuith

# compositor and display server
sudo pacman -S hyprland wayland hyprpaper hyprlock 
yay -S hyprpicker
ln -s $HOME/.dotfiles/.config/hypr/ $HOME/.config/hypr

# gtk theme
sudo pacman -S sassc gnome-themes-extra gtk-engine-murrine nwg-look
yay -S awf-gtk4 awf-gtk3
cd $HOME/.dotfiles/.themes/Orchis
./install.sh -c dark -s standard -i arch --round 5px --tweaks primary -t purple
wget https://github.com/EliverLara/candy-icons/archive/refs/heads/master.zip
unzip master.zip -c $HOME/.local/share/icons/
# and change gtk & icon themes
nwg-look

# desktop manager
sudo pacman -S lemurs
sudo systemctl disable display-manager.service
sudo systemctl enable lemurs.service
sudo cp $HOME/.dotfiles/.config/lemurs/hypr /etc/lemurs/wayland/hypr
sudo chmod 755 /etc/lemurs/wayland/hypr
sed -i 's/ExecStart\=\/usr\/bin\/lemurs/ExecStart=\/usr\/bin\/lemurs -c \/home\/hayk\/.dotfiles\/.config\/lemurs\/config.toml/' /usr/lib/systemd/system/lemurs.service

# logout manager
sudo pacman -S wlogout
ln -s $HOME/.dotfiles/.config/wlogout/ $HOME/.config/wlogout

# scripts
ln -s $HOME/.dotfiles/scripts/wlprop $HOME/.local/bin/wlprop

# waybar
sudo pacman -S waybar
ln -s $HOME/.dotfiles/.config/waybar/ $HOME/.config/waybar

# thunar
sudo pacman -S thunar

# spotify
sudo pacman -S playerctl spotify-launcher
mkdir -p $HOME/.config/systemd/user/
cp $HOME/.dotfiles/.config/systemd/playerctld.service $HOME/.config/systemd/user/
systemctl daemon-reload
systemctl enable --user playerctld.service --now
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh

# python
sudo pacman -S python python-virtualenv python-pipx

# extra
sudo pacman -S w3m usbutils imv
yay -S sioyek-git
ln -s $HOME/.dotfiles/.config/sioyek/ $HOME/.config/sioyek
ln -s $HOME/.dotfiles/.config/imv/ ~/.config/imv

# vscode
ln -s $HOME/.dotfiles/.config/code-flags.conf ~/.config
```

TODO:

- [x] waybar
  - [x] weather
  - [x] media
  - [x] groups
- [ ] thunar
- [ ] wofi
- [x] power management: https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Changing_suspend_method
- [ ] plugins
- [ ] notifications
- [ ] brightness & volume indicators
