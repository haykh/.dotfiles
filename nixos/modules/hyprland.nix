{ pkgs, ... }:

{

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  programs.hyprlock.enable = true;
  security.pam.services.hyprlock = { };

  services.displayManager.sddm = {
    enable = true;
    # SDDM greeter runs under X11 — Wayland greeter fails to reclaim the
    # display after a Wayland user session exits on AMD, leaving the kernel
    # TTY (USB-C / amdgpu noise) visible instead of the login screen.
    # User sessions remain Wayland via defaultSession below.
    wayland.enable = false;
    # To use the "pixie" SDDM theme, place a derivation in environment.systemPackages
    # that installs the theme to $out/share/sddm/themes/pixie/ and set:
    #   services.displayManager.sddm.theme = "pixie";
    # See e.g. https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/themes/sddm-sugar-dark
  };
  services.displayManager.defaultSession = "hyprland-uwsm";

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
    xdgOpenUsePortal = true;
    config.common.default = [
      "hyprland"
      "gtk"
    ];
  };

  environment.systemPackages = with pkgs; [
    hyprpolkitagent
    qt6.qtwayland
  ];

}
