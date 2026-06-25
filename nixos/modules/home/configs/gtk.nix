{
  config,
  lib,
  pkgs,
  cfg,
  ...
}:

let
  this = config.my.configs.gtk;
  themePkg = pkgs.${cfg.gtktheme.main.pkg};
  themeName = cfg.gtktheme.main.interface; # "Fluent-Dark"
  gtk4Dir = "${themePkg}/share/themes/${themeName}/gtk-4.0";
  themeAttr = {
    name = themeName;
    package = themePkg;
  };
in
{

  options.my.configs.gtk.enable = lib.mkEnableOption "GTK theming";

  config = lib.mkIf this.enable {

    gtk = {
      enable = true;

      # Sets the theme NAME in gtk-3.0/4.0 settings.ini + gsettings. This is what
      # themes GTK3 apps and their right-click context menus (nm-applet, blueman,
      # pavucontrol, nm-connection-editor, …) — previously only prefer-dark was
      # set, so they fell back to Adwaita.
      theme = themeAttr;
      iconTheme = {
        name = cfg.gtktheme.icon.interface;
        package = pkgs.${cfg.gtktheme.icon.pkg};
      };
      cursorTheme = {
        name = cfg.gtktheme.cursor.interface;
        package = pkgs.${cfg.gtktheme.cursor.pkg};
        size = 32;
      };

      gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
      # Keep applying the theme to GTK4 settings.ini (pre-26.05 default behavior);
      # silences the default-change warning on our stateVersion.
      gtk4.theme = themeAttr;
    };

    # GTK4 / libadwaita apps (Nautilus) ignore the theme name above — they only
    # honour the light/dark preference. Forcing the Fluent CSS into the GTK4
    # config dir makes them pick up the theme. Note: apps that lean hard on
    # libadwaita widgets may end up only partially themed.
    xdg.configFile = {
      "gtk-4.0/gtk.css".source = "${gtk4Dir}/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${gtk4Dir}/gtk-dark.css";
      "gtk-4.0/assets".source = "${gtk4Dir}/assets";
    };

    # Forces the theme for GTK3 apps regardless of settings.ini propagation.
    home.sessionVariables.GTK_THEME = cfg.gtktheme.main.env;

  };

}
