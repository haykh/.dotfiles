{ pkgs, ... }:

{

  services = {
    xserver.desktopManager.gnome.enable = true;
    xserver.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    udev.packages = with pkgs; [ gnome-settings-daemon ];
    touchegg.enable = true;
  };

}
