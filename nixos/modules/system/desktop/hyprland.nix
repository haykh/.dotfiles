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

    programs.thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-volman
        thunar-archive-plugin
        thunar-vcs-plugin
      ];
    };
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
          CursorTheme = cfg.gtktheme.cursor.interface;
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
      qt6.qtwayland

      (inputs.pixie-sddm.packages.${pkgs.stdenv.hostPlatform.system}.pixie-sddm.override {
        background = ../../../assets/wallpaper.jpg;
        accentColor = cfg.gtktheme.accent;
        avatar = ../../../assets/h.jpg;
        autoColor = true;
        fontFamily = "MonaspiceKr Nerd Font";
        fontSize = 14;
      })
    ];

  };

}
