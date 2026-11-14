{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  desktop = config.my.desktops.hyprland;
in
{

  # Shared login screen, services and apps live in ./common.nix.
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

    services.displayManager.defaultSession = "hyprland-uwsm";

    xdg.portal.config.common.default = [
      "hyprland"
      "gtk"
    ];

    environment.systemPackages = with pkgs; [
      hyprpolkitagent
    ];

  };

}
