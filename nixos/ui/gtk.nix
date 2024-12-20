{ pkgs, dotfiles, ... }:

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

  home.packages = with pkgs; [
    capitaine-cursors-themed
    fluent-gtk-theme
    fluent-icon-theme

    gjs
    gobject-introspection-unwrapped

    gnomeExtensions.hide-universal-access
    gnomeExtensions.vitals
    gnomeExtensions.user-themes
  ];

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/wezterm/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/firefox/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-icons/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/nautilus/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/wezterm" = {
      binding = "<Super>t";
      command = "wezterm";
      name = "open-terminal";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/firefox" = {
      binding = "<Super>f";
      command = "firefox";
      name = "open-firefox";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/nautilus" = {
      binding = "<Super>e";
      command = "nautilus";
      name = "open-nautilus";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-icons" = {
      binding = "<Super>i";
      command = "${dotfiles}/.config/rofi/apps/launch --nerdicons > /dev/null 2> &1";
      name = "rofi-icons";
    };

    "org/gnome/desktop/interface" = {
      text-scaling-factor = 1.25;
    };

    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "hide-universal-access@akiirui.github.io"
        "Vitals@CoreCoding.com"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
      ];

    };
    "org/gnome/desktop/wm/preferences" = {
      resize-with-right-button = true;
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = true;
    };
    "org/gnome/desktop/interface" = {
      gtk-theme = "Fluent-dark";
      icon-theme = "Fluent-dark";
      cursor-theme = "Capitaine Cursors";
      color-scheme = "prefer-dark";
    };
    "org/gnome/interface" = {
      accent-color = "pink";
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${dotfiles}/wallpapers/blueish-sunrise.jpg";
      picture-uri-dark = "file://${dotfiles}/wallpapers/blueish-sunrise.jpg";
    };

    # "org/gnome/shell/extensions/user-theme" = {
    #   name = "palenight";
    # };

    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = [
        "_temperature_acpi_thermal zone_"
        "_memory_allocated_"
        "__network-rx_max__"
        "_voltage_bat1_in0_"
      ];
    };

  };

  home.sessionVariables.GTK_THEME = "Fluent:dark";
}
