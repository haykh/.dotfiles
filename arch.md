```sh
# sound
sudo pacman -S pipewire-media-session pipewire-jack pipewire-pulse pipewire-alsa

# wireless
sudo pacman -S iwd network-manager
sudo pacman -S wireless-regdb
sudo nvim /etc/conf.d/wireless-regdom
# uncomment WIRELESS_REGDOM="US"

# bluetooth
sudo pacman -S bluez blueman bluez-utils

# compositor and display server
sudo pacman -S hyprland wayland hyprpaper hyprlock
sudo ln -s $HOME/.dotfiles/.config/hypr/ $HOME/.config/hypr

# desktop manager
sudo pacman -S lemurs
sudo systemctl enable lemurs.service
sudo ln -s $HOME/.dotfiles/.config/lemurs/hypr /etc/lemurs/wayland/hypr
sudo chmod 755 $HOME/.dotfiles/.config/lemurs/hypr

# logout manager
sudo pacman -S wlogout
sudo ln -s $HOME/.dotfiles/.config/wlogout/ $HOME/.config/wlogout

# scripts
ln -s $HOME/.dotfiles/scripts/wlprop $HOME/.local/bin/wlprop

# utils
sudo pacman -S power-profiles-daemon
sudo systemctl enable power-profiles-daemon.service
```

TODO:

- [ ] waybar
- [ ] thunar
- [ ] wofi
- [ ] power management: https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Changing_suspend_method
- [ ] plugins
- [ ] notifications
- [ ] brightness & volume indicators
