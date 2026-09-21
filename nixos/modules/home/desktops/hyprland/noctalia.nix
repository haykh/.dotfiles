{ cfg, inputs, ... }:

{

  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;
    systemd.enable = true;

    settings = {
      bar = {
        default = {
          background_opacity = 0.75;
          center = [
            "cat"
            "clock"
            "weather"
          ];
          end = [
            "tray"
            "network"
            "bluetooth"
            "volume"
            "group:g1"
            "group:g2"
            "notifications"
          ];
          font_weight = 400;
          margin_edge = 5;
          margin_ends = 5;
          scale = 1.2;
          start = [
            "workspaces"
            "media"
            "audio_visualizer"
          ];
          thickness = 40;
          capsule_group = [
            {
              fill = "surface_variant";
              id = "g1";
              members = [
                "battery"
                "caffeine"
              ];
              opacity = 1.0;
              padding = 6.0;
            }
            {
              fill = "surface_variant";
              id = "g2";
              members = [
                "ram"
                "cpu"
              ];
              opacity = 1.0;
              padding = 6.0;
            }
          ];
        };
      };
      desktop_widgets = {
        schema_version = 2;
        widget_order = [ ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = {

        };
      };
      location = {
        auto_locate = true;
      };
      lockscreen_widgets = {
        enabled = true;
        schema_version = 2;
        widget_order = [
          "lockscreen-login-box@DP-3"
          "lockscreen-login-box@eDP-1"
          "lockscreen-widget-0000000000000001"
          "lockscreen-widget-0000000000000002"
        ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = {
          "lockscreen-login-box@DP-3" = {
            box_height = 196.0;
            box_width = 720.0;
            cx = 1536.0;
            cy = 1609.0;
            output = "DP-3";
            placement_height = 0.0;
            placement_width = 0.0;
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              center_password_text = false;
              input_opacity = 1.0;
              input_radius = 6.0;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_session_buttons = true;
              show_unlock_hint = true;
              show_weather = true;
            };
          };
          "lockscreen-login-box@eDP-1" = {
            box_height = 196.0;
            box_width = 720.0;
            cx = 1024.0;
            cy = 1143.0;
            output = "eDP-1";
            placement_height = 1280.0;
            placement_width = 2048.0;
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              center_password_text = false;
              input_opacity = 1.0;
              input_radius = 6.0;
              layout = "compact";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_session_buttons = true;
              show_unlock_hint = true;
              show_weather = false;
            };
          };
          lockscreen-widget-0000000000000001 = {
            box_height = 80.0;
            box_width = 432.0;
            cx = 1024.0;
            cy = 768.0;
            output = "eDP-1";
            placement_height = 1280.0;
            placement_width = 2048.0;
            rotation = 0.0;
            type = "clock";
            settings = {
              background = false;
              format = "{:%l:%M%P @ %d %h}";
              shadow = true;
            };
          };
          lockscreen-widget-0000000000000002 = {
            box_height = 64.0;
            box_width = 224.0;
            cx = 1024.0;
            cy = 856.0;
            output = "eDP-1";
            placement_height = 1280.0;
            placement_width = 2048.0;
            rotation = 0.0;
            type = "weather";
            settings = {
              background = false;
            };
          };
        };
      };
      nightlight = {
        enabled = true;
      };
      plugins = {
        enabled = [ "noctalia/bongocat" ];
      };
      shell = {
        launch_apps_as_systemd_services = true;
        panel = {
          open_near_click_control_center = true;
          transparency_mode = "glass";
        };
        screen_corners = {
          enabled = true;
        };
      };
      theme = {
        source = "wallpaper";
        wallpaper_scheme = "faithful";
        templates = {
          enable_builtin_templates = false;
          enable_community_templates = false;
        };
      };
      wallpaper = {
        directory = "${cfg.dotfiles}/wallpapers";
        default = {
          path = cfg.theme.wallpaper;
        };
        last = {
          path = cfg.theme.wallpaper;
        };
      };
      widget = {
        audio_visualizer = {
          bands = 64;
          mirrored = false;
          show_when_idle = true;
          width = 128.0;
        };
        brightness = {
          show_label = false;
        };
        cat = {
          # evtest-readable keyboards, matched by glob so hotplugging works:
          # the built-in Framework keyboard module, any USB/dongle keyboard,
          # and Bluetooth ones via the by-id symlink from the udev rule in
          # hosts/fw16/hardware.nix. Needs `evtest` and membership of `input`.
          input_devices = [ "/dev/input/by-id/*-event-kbd" ];
          type = "noctalia/bongocat:cat";
        };
        clock = {
          format = "{:%l:%M%P @ %d %h}";
        };
        cpu = {
          show_value = true;
          stat = "cpu_temp";
        };
        media = {
          hide_when_no_media = true;
          title_scroll = "always";
        };
        network = {
          show_label = false;
        };
        ram = {
          show_value = true;
        };
        sysmon = {
          capsule = true;
          visualization = "graph";
          show_value = true;
        };
        tray = {
          capsule = true;
          hidden = [
            "blueman"
            "Network"
          ];
        };
        weather = {
          show_condition = false;
        };
      };
    };
  };

}
