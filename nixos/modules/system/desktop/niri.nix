{
  config,
  lib,
  pkgs,
  ...
}:

let
  desktop = config.my.desktops.niri;
in
{

  # Shared login screen, services and apps live in ./common.nix; the niri
  # config itself is in modules/home/desktops/niri.
  options.my.desktops.niri.enable = lib.mkEnableOption "niri desktop (system side)";

  config = lib.mkIf desktop.enable {

    # Installs niri, its `niri` session for SDDM (niri-session + systemd units)
    # and the gnome portal it uses for screencasting.
    programs.niri = {
      enable = true;
      # Keep the GTK file chooser (as on Hyprland) rather than pulling in
      # Nautilus for xdg-desktop-portal-gnome's.
      useNautilus = false;
    };

    services.displayManager.defaultSession = "niri";

    environment.systemPackages = with pkgs; [
      # X11 apps: niri starts it on demand when it is on PATH and sets DISPLAY.
      xwayland-satellite
    ];

  };

}
