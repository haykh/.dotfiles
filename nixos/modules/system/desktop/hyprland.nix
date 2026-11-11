{
  config,
  lib,
  pkgs,
  inputs,
  cfg,
  ...
}:

let
  desktop = config.my.desktops.hyprland;

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

  options.my.desktops.hyprland.enable = lib.mkEnableOption "Hyprland desktop (system side)";

  config = lib.mkIf desktop.enable {

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    programs.hyprlock.enable = true;
    security.pam.services.hyprlock = { };

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
    services.displayManager.defaultSession = "hyprland-uwsm";

    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        # xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      xdgOpenUsePortal = true;
      config.common.default = [
        "hyprland"
        "gtk"
      ];
    };

    environment.systemPackages = with pkgs; [
      file-roller
      hyprpolkitagent
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
