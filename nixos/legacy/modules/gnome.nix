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

  environment = with pkgs; {
    systemPackages = [
      touchegg
      gnome-tweaks
      gnome-extension-manager
      gdm-settings
    ];

    gnome.excludePackages = (
      with pkgs;
      [
        gnome-photos
        gnome-tour
        gnome-music
        gnome-screenshot
        epiphany
        geary
        totem
      ]
    );
  };

}
