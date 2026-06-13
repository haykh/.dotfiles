{ inputs, ... }:

{

  imports = [ inputs.noctalia.homeModules.default ];

  programs.noctalia = {
    enable = true;

    settings = {
      bar = {
        default = {
          background_opacity = 0.75;
          center = [
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
                "caffeine"
                "battery"
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
          "lockscreen-login-box@eDP-1"
          "lockscreen-widget-0000000000000001"
          "lockscreen-widget-0000000000000002"
          "lockscreen-widget-0000000000000003"
        ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = {
          "lockscreen-login-box@eDP-1" = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 1024.0;
            cy = 1143.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              input_opacity = 1.0;
              input_radius = 6.0;
              show_login_button = true;
            };
          };
          lockscreen-widget-0000000000000001 = {
            box_height = 80.0;
            box_width = 432.0;
            cx = 1024.0;
            cy = 968.0;
            output = "eDP-1";
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
            cy = 1056.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "weather";
            settings = {
              background = false;
            };
          };
          lockscreen-widget-0000000000000003 = {
            box_height = 0.0;
            box_width = 0.0;
            cx = 1024.0;
            cy = 640.0;
            output = "eDP-1";
            rotation = 0.0;
            type = "fancy_audio_visualizer";
            settings = {
              background = false;
              fade_when_idle = false;
              visualization_mode = "wave";
            };
          };
        };
      };
      nightlight = {
        enabled = true;
      };
      shell = {
        ui_scale = 1.1;
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
        directory = "/home/hayk/.dotfiles/wallpapers";
        default = {
          path = "/home/hayk/.dotfiles/wallpapers/blueish-sunrise.jpg";
        };
        last = {
          path = "/home/hayk/.dotfiles/wallpapers/blueish-sunrise.jpg";
        };
      };
      widget = {
        brightness = {
          show_label = false;
        };
        clock = {
          format = "{:%l:%M%P @ %d %h}";
        };
        cpu = {
          display = "text";
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
          display = "text";
        };
        sysmon = {
          capsule = true;
          display = "graph";
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
