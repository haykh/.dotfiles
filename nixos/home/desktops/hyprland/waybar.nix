{ pkgs, ... }:

let
  # waybar's built-in clock uses libfmt, which rejects the GNU strftime
  # extensions needed for "8:29pm" (no leading zero via %-I, lowercase via %P).
  # glibc's date(1) supports them, so drive a custom module from a script.
  # Emits JSON so we keep a calendar tooltip.
  clockScript = pkgs.writeShellScript "waybar-clock" ''
    text=$(${pkgs.coreutils}/bin/date +'%-I:%M%P  %a %b %d')
    tip="<tt>$(${pkgs.util-linux}/bin/cal)</tt>"
    ${pkgs.jq}/bin/jq -nc --arg t "$text" --arg tt "$tip" '{text: $t, tooltip: $tt}'
  '';
in
{

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 6;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ "custom/clock" ];
        modules-right = [
          "tray"
          "network"
          "pulseaudio"
          "battery"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          on-click = "activate";
          all-outputs = true;
        };
        "hyprland/window" = {
          max-length = 60;
        };
        "custom/clock" = {
          exec = "${clockScript}";
          interval = 10;
          return-type = "json";
          tooltip = true;
        };
        battery = {
          format = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          states = {
            warning = 30;
            critical = 15;
          };
        };
        network = {
          format-wifi = "{essid} ";
          format-ethernet = "";
          format-disconnected = "";
          tooltip-format = "{ipaddr}/{cidr}";
        };
        pulseaudio = {
          format = "{volume}% {icon}";
          # Keep text in the muted state so it's visible even if the glyph
          # font is missing (otherwise a muted sink looks like an empty bar).
          format-muted = "muted ";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          scroll-step = 5;
          on-click = "pavucontrol"; # open mixer
          on-click-right = "${pkgs.pamixer}/bin/pamixer -t"; # toggle mute
        };
        tray = {
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        font-family: "Noto Sans", "MonaspiceKr Nerd Font";
        font-size: 12px;
        min-height: 0;
      }
      window#waybar {
        background: rgba(30, 30, 46, 0.85);
        color: #cdd6f4;
        border-bottom: 1px solid #313244;
      }
      #workspaces button {
        padding: 0 8px;
        color: #cdd6f4;
        background: transparent;
      }
      #workspaces button.active {
        background: #585b70;
        color: #ffffff;
      }
      #workspaces button:hover {
        background: #45475a;
      }
      #custom-clock,
      #battery,
      #network,
      #pulseaudio,
      #tray,
      #window {
        padding: 0 12px;
      }
      #battery.warning {
        color: #f9e2af;
      }
      #battery.critical {
        color: #f38ba8;
      }
    '';
  };

}
