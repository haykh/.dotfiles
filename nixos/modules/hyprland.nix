{
  pkgs,
  inputs,
  cfg,
  ...
}:

{

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  programs.hyprlock.enable = true;
  security.pam.services.hyprlock = { };

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-volman
      thunar-archive-plugin
    ];
  };
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  services.displayManager.sddm = {
    enable = true;
    theme = "pixie";
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

    (inputs.pixie-sddm.packages.${pkgs.stdenv.hostPlatform.system}.pixie-sddm.override {
      accentColor = cfg.gtktheme.accent;
      autoColor = true;
      fontFamily = "MonaspiceKr Nerd Font";
      fontSize = 14;
    })
  ];

}
