{
  pkgs,
  cfg,
  ...
}:

{

  gtk = {
    enable = true;

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  home.packages = [
    pkgs.${cfg.gtktheme.main.pkg}
    pkgs.${cfg.gtktheme.icon.pkg}
    pkgs.${cfg.gtktheme.cursor.pkg}
  ];

  home.sessionVariables.GTK_THEME = cfg.gtktheme.main.env;

}
