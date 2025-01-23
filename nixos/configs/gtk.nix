{
  pkgs,
  gtktheme,
  bindings,
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
    pkgs.${gtktheme.main.pkg}
    pkgs.${gtktheme.icon.pkg}
    pkgs.${gtktheme.cursor.pkg}

    pkgs.gnomeExtensions.user-themes
    pkgs.gnomeExtensions.hide-universal-access
    pkgs.gnomeExtensions.vitals
    pkgs.gnomeExtensions.blur-my-shell
    pkgs.gnomeExtensions.dash-to-dock
    pkgs.gnomeExtensions.compiz-alike-magic-lamp-effect
    pkgs.gnomeExtensions.weather-oclock
  ];

  dconf.settings =
    builtins.listToAttrs (
      map (name: {
        name = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${name}";
        value = {
          name = name;
          binding = bindings.${name}.binding;
          command = bindings.${name}.action;
        };
      }) (builtins.attrNames bindings)
    )
    // {
      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = (
          builtins.map (x: "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${x}/") (
            builtins.attrNames bindings
          )
        );
      };

      "org/gnome/desktop/wm/keybindings" = {
        minimize = [ "<Super>m" ];
        toggle-quick-settings = "disabled";
        toggle-message-tray = "disabled";
      };

      "org/gnome/shell/keybindings" = {
        screenshot = [ ];
        show-screenshot-ui = [ ];
        screenshot-window = [ ];
      };

      "org/gnome/mutter" = {
        dynamic-workspaces = true;
      };

      "org/gnome/desktop/interface" = {
        text-scaling-factor = 1.25;
        gtk-theme = "${gtktheme.main.interface}";
        icon-theme = "${gtktheme.icon.interface}";
        cursor-theme = "${gtktheme.cursor.interface}";
        color-scheme = "prefer-dark";
        accent-color = "${gtktheme.accent}";
      };
      "org/gnome/desktop/wm/preferences" = {
        resize-with-right-button = true;
        button-layout = "appmenu:minimize,maximize,close";
      };
      "org/gnome/desktop/background" = {
        picture-uri = "file://${gtktheme.wallpaper}";
        picture-uri-dark = "file://${gtktheme.wallpaper}";
      };

      # text editor
      "org/gnome/TextEditor" = {
        style-scheme = "Adwaita-dark";
        custom-font = "MonaspiceKr Nerd Font 12";
        use-system-font = false;
        show-grid = true;
        show-map = true;
      };

      "org/gnome/shell" = {
        favorite-apps = [
          "org.wezfurlong.wezterm.desktop"
          "firefox.desktop"
          "thunderbird.desktop"
          "obsidian.desktop"
          "slack.desktop"
          "org.gnome.Nautilus.desktop"
        ];
        disable-user-extensions = false;
        enabled-extensions = [
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "hide-universal-access@akiirui.github.io"
          "Vitals@CoreCoding.com"
          "blur-my-shell@aunetx"
          "dash-to-dock@micxgx.gmail.com"
          "compiz-alike-magic-lamp-effect@hermes83.github.com"
          "weatheroclock@CleoMenezesJr.github.io"
        ];
      };

      ## Extension settings

      # for blur-my-shell
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

      # for vitals
      "org/gnome/shell/extensions/vitals" = {
        hot-sensors = [
          "_temperature_acpi_thermal zone_"
          "_memory_allocated_"
          "__network-rx_max__"
          "_battery_rate_"
        ];
      };

      # for dash2dock
      "org/gnome/shell/extensions/dash-to-dock" = {
        dock-position = "BOTTOM";
        preferred-monitor-by-connector = "eDP";
        preferred-monitor = -2;
        height-fraction = 0.9;
        background-opacity = 0.8;
        dash-max-icon-size = 64;
        apply-custom-theme = true;
        show-mounts = false;
        intellihide = false;
        scroll-action = "switch-workspace";
        show-show-apps-button = false;
      };

      # for compiz-alike-magic-lamp-effect
      "org/gnome/shell/extensions/ncom/github/hermes83/compiz-alike-magic-lamp-effect" = {
        duration = 200.0;
      };

      # for weather-oclock
      "org/gnome/shell/extensions/weather-oclock" = {
        weather-after-clock = true;
      };

    };

  home.sessionVariables.GTK_THEME = gtktheme.main.env;
}
