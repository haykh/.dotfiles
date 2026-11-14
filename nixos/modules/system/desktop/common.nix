{
  config,
  lib,
  pkgs,
  inputs,
  cfg,
  ...
}:

# System pieces shared by the Wayland desktops (Hyprland, niri): login screen,
# file-manager services, keyring/polkit and common apps. Active when either is
# enabled; each desktop module adds its compositor, portals and session.

let
  desktops = config.my.desktops;

  # hyprfm detects gvfs backends (trash, MTP, AFC, gphoto2) by probing FHS
  # paths like /usr/share/gvfs/mounts/*.mount, which don't exist on NixOS, so
  # it reports "GVFS backend missing" and hides MTP/AFC devices. Point those
  # probes at the gvfs package. The leading quote keeps the Flatpak
  # "/run/host/usr/share/gvfs" candidates untouched.
  hyprfm = inputs.hyprfm.packages.${pkgs.stdenv.hostPlatform.system}.hyprfm.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace src/services/dependencychecker.cpp src/models/devicemodel.cpp \
        --replace-fail '"/usr/share/gvfs/' '"${config.services.gvfs.package}/share/gvfs/'
    '';
  });
in
{

  config = lib.mkIf (desktops.hyprland.enable || desktops.niri.enable) {

    services.gvfs.enable = true;
    services.tumbler.enable = true;
    services.upower.enable = true;

    services.displayManager.sddm = {
      enable = true;
      theme = "pixie";
      wayland = {
        enable = true;
      };
      settings = {
        Theme = {
          CursorTheme = cfg.theme.cursor.interface;
          CursorSize = 32;
        };
      };
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs.kdePackages; [
        qtsvg
        qtdeclarative
        qt5compat
      ];
    };

    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      xdgOpenUsePortal = true;
    };

    environment.systemPackages = with pkgs; [
      file-roller
      hyprfm
      qt6.qtwayland

      (inputs.pixie-sddm.packages.${pkgs.stdenv.hostPlatform.system}.pixie-sddm.override {
        background = ../../../assets/wallpaper.jpg;
        accentColor = cfg.theme.accent;
        avatar = ../../../assets/h.jpg;
        autoColor = true;
        fontFamily = "MonaspiceKr Nerd Font";
        fontSize = 14;
      })
    ];

  };

}
