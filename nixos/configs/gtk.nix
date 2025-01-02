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

    gnomeExtensions.hide-universal-access
    gnomeExtensions.vitals
    gnomeExtensions.user-themes
  ];

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/wezterm/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/firefox/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/nautilus/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-icons/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-refs/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-calc/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-moji/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-drun/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/largesize/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/pickcolor/"
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
      binding = "<Control><Super>i";
      command = "${dotfiles}/.config/rofi/apps/launch --nerdicons > /dev/null 2> &1";
      name = "rofi-icons";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-refs" = {
      binding = "<Control><Super>a";
      command = "${dotfiles}/.config/rofi/apps/launch --refs > /dev/null 2> &1";
      name = "rofi-refs";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-calc" = {
      binding = "<Control><Super>c";
      command = "${dotfiles}/.config/rofi/apps/launch --calc > /dev/null 2> &1";
      name = "rofi-calc";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-moji" = {
      binding = "<Control><Super>j";
      command = "${dotfiles}/.config/rofi/apps/launch --emojis > /dev/null 2> &1";
      name = "rofi-moji";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/rofi-drun" = {
      binding = "<Control><Super>r";
      command = "${dotfiles}/.config/rofi/apps/launch --drun > /dev/null 2> &1";
      name = "rofi-drun";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/largesize" = {
      binding = "<Super>equal";
      command = "${dotfiles}/scripts/actions.sh --enlarge";
      name = "increase-window-size";
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/pickcolor" = {
      binding = "<Control>Print";
      command = "${dotfiles}/scripts/actions.sh --pick-color";
      name = "color-picker";
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
        "blur-my-shell@aunetx"
      ];
    };

    "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
      blur = true;
      brightness = 0.59999999999999998;
      sigma = 30;
      static-blur = true;
      style-dash-to-dock = 0;
    };
    "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
      brightness = 0.59999999999999998;
      sigma = 30;
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      brightness = 0.59999999999999998;
      sigma = 30;
    };
    "org/gnome/shell/extensions/blur-my-shell" = {
      settings-version = 2;
    };
    "org/gnome/shell/extensions/blur-my-shell/window-list" = {
      brightness = 0.59999999999999998;
      sigma = 30;
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
    "org/gnome/desktop/interface" = {
      accent-color = "#7295F6";
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
        "_battery_rate_"
      ];
    };

  };

  home.sessionVariables.GTK_THEME = "Fluent:dark";
}
