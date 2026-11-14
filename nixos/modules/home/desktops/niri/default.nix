{
  config,
  lib,
  pkgs,
  cfg,
  osConfig,
  ...
}:

# niri desktop (home side): ~/.config/niri/config.kdl plus two helper scripts.
# Active only when the host enables my.desktops.niri
# (modules/system/desktop/niri.nix). Ported from ../hyprland/hyprland.nix.
#
#   SUPER+S/G/M/D   Slack / Telegram / Tidal / Filen scratchpads (./scratch.sh)
#   SUPER+W         overview (also: 4-finger vertical swipe)
#   gestures        3-finger vertical: workspaces, 3-finger horizontal: columns
#   mouse           SUPER+left-drag moves, SUPER+right-drag resizes (built in)
#   lid             niri turns the internal panel off by itself on lid close
#
# Run `niri msg outputs` / `niri msg windows` inside niri to check names.

let
  niri = osConfig.programs.niri.package;
  noctalia = lib.getExe config.programs.noctalia.package;

  # KDL string literal (JSON escaping is valid KDL for these strings).
  q = builtins.toJSON;

  # Quake-style scratchpads (./scratch.sh): key, how to find the window
  # (app-id / title regexes) and how to launch it. Also drives their window
  # rules and binds below.
  scratchpads = {
    slack = {
      key = "Mod+S";
      app_id = "^[Ss]lack$";
      cmd = [ "slack" ];
    };
    telegram = {
      key = "Mod+G";
      app_id = "^org\\.telegram\\.desktop$";
      cmd = [ "Telegram" ];
    };
    tidal = {
      key = "Mod+M";
      app_id = "^tidal-hifi$";
      cmd = [ "tidal-hifi" ];
    };
    filen = {
      key = "Mod+D";
      app_id = "^electron$";
      title = "^Filen$";
      cmd = [ "filen-desktop" ];
    };
  };
  scratchpadsJson = pkgs.writeText "niri-scratchpads.json" (
    builtins.toJSON (
      lib.mapAttrs (_: s: {
        inherit (s) app_id cmd;
        title = s.title or "";
      }) scratchpads
    )
  );

  scratch = pkgs.writeShellApplication {
    name = "niri-scratch";
    runtimeInputs = [
      niri
      pkgs.jq
    ];
    text = ''
      scratchpads_json=${scratchpadsJson}
    ''
    + builtins.readFile ./scratch.sh;
  };

  # SUPER+equal: floating windows grow to 90% and center (as on Hyprland);
  # tiled ones maximize their column.
  bigCenter = pkgs.writeShellApplication {
    name = "niri-big-center";
    runtimeInputs = [
      niri
      pkgs.jq
    ];
    text = ''
      if niri msg --json focused-window | jq -e '.is_floating' >/dev/null; then
        niri msg action set-window-width "90%"
        niri msg action set-window-height "90%"
        niri msg action center-window
      else
        niri msg action maximize-column
      fi
    '';
  };

  screenshotCmd =
    grimArgs:
    ''${pkgs.grim}/bin/grim ${grimArgs} - | ${pkgs.satty}/bin/satty -f - --copy-command ${pkgs.wl-clipboard}/bin/wl-copy --output-filename "$HOME/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png"'';

  # ---- window rules (same apps as on Hyprland) ----
  # `rule match [lines]` renders one window-rule block.
  rule =
    {
      app-id ? null,
      title ? null,
    }:
    lines:
    lib.concatStringsSep "\n" (
      [
        "window-rule {"
        (
          "    match"
          + lib.optionalString (app-id != null) " app-id=${q app-id}"
          + lib.optionalString (title != null) " title=${q title}"
        )
      ]
      ++ map (l: "    " + l) lines
      ++ [ "}\n" ]
    );
  # Sizes are fractions of the monitor's working area (as strings, so the
  # generated file reads 0.6 rather than 0.600000).
  floatSized = w: h: [
    "open-floating true"
    "default-column-width { proportion ${w}; }"
    "default-window-height { proportion ${h}; }"
  ];
  # Below the bar, against the right edge.
  atTopRight = [ ''default-floating-position x=16 y=16 relative-to="top-right"'' ];

  # New floating windows open centered by default.
  floatCenter = m: rule m (floatSized "0.6" "0.8");
  floatCenterDialog = m: rule m [ "open-floating true" ];
  topRight = m: rule m (floatSized "0.33" "0.55" ++ atTopRight);
  # niri can't pin a window to all workspaces; it just floats top-right.
  pictureInPicture = m: rule m (floatSized "0.25" "0.27" ++ atTopRight);
  # opacity 0.1 is the faded look while sliding away; ./scratch.sh and
  # ./scratchd.sh switch it off (toggle-window-rule-opacity) while shown.
  scratchpad = m: rule m (floatSized "0.8" "0.85" ++ [ "opacity 0.1" ]);

  windowRules = lib.concatStrings [
    (floatCenter { app-id = "^com\\.mitchellh\\.ghostty$"; })
    (floatCenter { app-id = "^zen"; })
    (floatCenter { app-id = "^[Tt]horium"; })
    (floatCenter { app-id = "^com\\.gabm\\.satty$"; })
    (floatCenter { app-id = "oculante"; })
    (floatCenter { app-id = "^org\\.pwmt\\.zathura$"; })
    (floatCenter { app-id = "^org\\.gnome\\.TextEditor$"; })
    (floatCenter { app-id = "^mpv$"; })
    (floatCenter { app-id = "^hyprfm$"; })
    (floatCenterDialog { app-id = "^com\\.wolfram\\.Wolfram\\."; })

    # after the zen rule, so its size/position win
    (pictureInPicture {
      app-id = "^zen";
      title = "^Picture-in-Picture$";
    })

    (topRight { app-id = "^(org\\.pulseaudio\\.pavucontrol|pavucontrol)$"; })
    (topRight { app-id = "^(\\.blueman-manager-wrapped|blueman-manager)$"; })
    (topRight { app-id = "^nm-connection-editor$"; })

    (lib.concatMapStrings (
      s:
      scratchpad {
        app-id = s.app_id;
        title = s.title or null;
      }
    ) (lib.attrValues scratchpads))

    # noctalia's settings window (from noctalia's niri guide)
    (rule { app-id = "^dev\\.noctalia\\.Noctalia$"; } [
      "open-floating true"
      "default-column-width { fixed 1080; }"
      "default-window-height { fixed 920; }"
    ])
  ];

  # Workspace keys that skip the scratchpad stash (./workspace.sh).
  ws = pkgs.writeShellApplication {
    name = "niri-ws";
    runtimeInputs = [
      niri
      pkgs.jq
    ];
    text = builtins.readFile ./workspace.sh;
  };
  wsSpawn = args: spawn ([ (lib.getExe ws) ] ++ args);

  # SUPER+focus / SUPER+SHIFT+move for workspaces 1-9.
  workspaceBinds = lib.concatMapStrings (i: ''
    Mod+${toString i} { ${
      wsSpawn [
        "focus"
        (toString i)
      ]
    } }
    Mod+Shift+${toString i} { ${
      wsSpawn [
        "move"
        (toString i)
      ]
    } }
  '') (lib.range 1 9);

  spawn = args: "spawn ${lib.concatMapStringsSep " " q args};";
  scratchBinds = lib.concatStrings (
    lib.mapAttrsToList (name: s: ''
      ${s.key} { ${
        spawn [
          (lib.getExe scratch)
          name
        ]
      } }
    '') scratchpads
  );

  # Volume/brightness repeat (niri's default) and work on the lock screen.
  locked = "allow-when-locked=true";

  configKdl = pkgs.writeText "niri-config.kdl" ''
    // Generated by home-manager from modules/home/desktops/niri/default.nix.

    ///////////////
    // MONITORS //
    ///////////////

    // Internal panel: its connector flips between eDP-1 and eDP-2 depending
    // on GPU enumeration order, so configure both. The mode without a
    // refresh rate picks the highest one (165 Hz).
    output "eDP-1" {
        mode "2560x1600"
        scale 1.25
        variable-refresh-rate
    }
    output "eDP-2" {
        mode "2560x1600"
        scale 1.25
        variable-refresh-rate
    }
    // Desk Dells (same model, so matched by serial). Positions are in logical
    // px: 3840 / 1.25 = 3072, so the right one starts at x=3072.
    output "Dell Inc. DELL U3223QE CTS50P3" {
        mode "3840x2160"
        scale 1.25
        position x=0 y=0
    }
    output "Dell Inc. DELL U3223QE GMJJXN3" {
        mode "3840x2160"
        scale 1.25
        position x=3072 y=0
    }
    output "Dell Inc. DELL S2722DGM 6LH66P3" {
        mode "2560x1440"
        scale 1.25
        variable-refresh-rate
    }

    ///////////
    // INPUT //
    ///////////

    input {
        keyboard {
            xkb {
                layout "us,ru"
                variant ",phonetic"
                options "grp:win_space_toggle"
            }
            numlock
        }
        touchpad {
            tap
            dwt
            natural-scroll
            scroll-factor 0.2
            accel-speed 0.0
            accel-profile "adaptive"
        }
        mouse {
            accel-speed -0.3
            accel-profile "flat"
        }
        // Like Hyprland's follow_mouse = 1, but without scrolling the view to
        // a column that is only partly on screen.
        focus-follows-mouse max-scroll-amount="0%"
    }

    cursor {
        xcursor-theme ${q cfg.theme.cursor.interface}
        xcursor-size 32
    }

    /////////////////
    // ENVIRONMENT //
    /////////////////

    environment {
        GDK_BACKEND "wayland,x11"
        QT_QPA_PLATFORM "wayland;xcb"
        SDL_VIDEODRIVER "wayland"
        CLUTTER_BACKEND "wayland"
        ELECTRON_OZONE_PLATFORM_HINT "auto"
        // hyprfm's "Open in Terminal" launches $TERMINAL (defaults to kitty)
        TERMINAL "ghostty"
    }

    ///////////////
    // AUTOSTART //
    ///////////////

    // noctalia runs as a systemd user service (graphical-session.target) and
    // is also the polkit agent here.
    spawn-at-startup "${pkgs.networkmanagerapplet}/bin/nm-applet" "--indicator"
    spawn-at-startup "${pkgs.blueman}/bin/blueman-applet"
    spawn-at-startup "${pkgs.wl-clipboard}/bin/wl-paste" "--watch" "${pkgs.cliphist}/bin/cliphist" "store"

    ///////////////////
    // LOOK AND FEEL //
    ///////////////////

    layout {
        gaps 8
        center-focused-column "never"
        default-column-width { proportion 0.5; }
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
        focus-ring {
            off
        }
        border {
            width 1
            active-color "#9cb9dd"
            inactive-color "#131d2b"
        }
    }

    // The bar sits at the top-left, where niri's default hot corner would
    // open the overview; SUPER+W and the 4-finger swipe do that instead.
    gestures {
        hot-corners {
            off
        }
    }

    hotkey-overlay {
        skip-at-startup
    }

    // Window moves, incl. the scratchpad slide in/out: Hyprland's "overshot"
    // curve at speed 3 (300ms), as hyprland.nix used for windows and special
    // workspaces. ./scratch.sh's `slide` waits for it.
    animations {
        window-movement {
            duration-ms 300
            curve "cubic-bezier" 0.05 0.9 0.1 1.1
        }
    }

    // Ask apps to drop their own title bars (close/minimize/maximize), as
    // Hyprland did. Apps that insist on CSD (e.g. GTK4/libadwaita header
    // bars) keep them. Running apps need a restart to pick this up.
    prefer-no-csd

    // niri's blur boosts the colours behind translucent windows (saturation
    // 1.5 by default), where Hyprland's dimmed them; keep them neutral.
    // niri has no brightness setting to dim them further.
    blur {
        saturation 1.0
    }

    // noctalia: notification actions and window activation
    debug {
        honor-xdg-activation-with-invalid-serial
    }

    ///////////
    // RULES //
    ///////////

    // Rounded corners and blur for every window. Tiled windows only have the
    // wallpaper behind them, so the cheap xray blur is exact there; floating
    // ones blur what is actually underneath (as on Hyprland).
    window-rule {
        geometry-corner-radius 10
        clip-to-geometry true
        background-effect {
            blur true
        }
        // By default niri paints the border/focus ring as a solid rectangle
        // *behind* windows that draw their own decorations, which shows
        // through translucent ones (ghostty) as a flat light tint instead of
        // what's behind them. Draw it only around the edge.
        draw-border-with-background false
    }
    window-rule {
        match is-floating=true
        background-effect {
            xray false
        }
    }

    ${windowRules}

    // noctalia: blurred wallpaper behind the overview (noctalia's [backdrop])
    layer-rule {
        match namespace="^noctalia-backdrop"
        place-within-backdrop true
    }
    // noctalia blurs its own surfaces; blur what is really behind them
    layer-rule {
        match namespace="^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$"
        background-effect {
            xray false
        }
    }
    layer-rule {
        match namespace="^vicinae$"
        background-effect {
            blur true
            xray false
        }
    }

    ///////////
    // BINDS //
    ///////////

    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }

        // apps
        Mod+T { spawn "ghostty"; }
        Mod+F { spawn "zen"; }
        Mod+E { spawn "hyprfm"; }
    ${scratchBinds}
        Ctrl+Alt+Space { spawn "vicinae" "toggle"; }

        // window management
        Mod+Q { close-window; }
        Mod+V { toggle-window-floating; }
        Mod+Shift+V { fullscreen-window; }
        Mod+Equal { ${spawn [ (lib.getExe bigCenter) ]} }
        Mod+L { ${
          spawn [
            noctalia
            "msg"
            "session"
            "lock"
          ]
        } }
        Mod+Shift+E { quit; }

        // focus (vim keys); up/down continue into the workspace above/below
        Ctrl+Shift+H { focus-column-left; }
        Ctrl+Shift+L { focus-column-right; }
        Ctrl+Shift+K { ${wsSpawn [ "up" ]} }
        Ctrl+Shift+J { ${wsSpawn [ "down" ]} }

        // scrolling layout
        Mod+W { toggle-overview; }
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+J { move-window-down; }
        Mod+R { switch-preset-column-width; }
        Mod+Minus { set-column-width "-10%"; }
        Mod+Shift+Equal { set-column-width "+10%"; }
        Mod+BracketLeft { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }
        Mod+C { center-column; }
        Mod+WheelScrollDown cooldown-ms=150 { focus-column-right; }
        Mod+WheelScrollUp cooldown-ms=150 { focus-column-left; }
        Mod+WheelScrollRight { focus-column-right; }
        Mod+WheelScrollLeft { focus-column-left; }

        // workspaces (per monitor in niri)
    ${workspaceBinds}
        // screenshots
        Print { spawn-sh ${q (screenshotCmd ''-g "$(${pkgs.slurp}/bin/slurp)"'')}; }
        Shift+Print { spawn-sh ${q (screenshotCmd "")}; }

        // color picker
        Ctrl+Print { spawn "${pkgs.hyprpicker}/bin/hyprpicker" "-a"; }

        // volume / brightness (repeat while held)
        XF86AudioRaiseVolume ${locked} { spawn "${pkgs.pamixer}/bin/pamixer" "-i" "5"; }
        XF86AudioLowerVolume ${locked} { spawn "${pkgs.pamixer}/bin/pamixer" "-d" "5"; }
        XF86MonBrightnessUp ${locked} { spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "10%+"; }
        XF86MonBrightnessDown ${locked} { spawn "${pkgs.brightnessctl}/bin/brightnessctl" "set" "10%-"; }

        // mute / media (MPRIS via playerctl)
        XF86AudioMute ${locked} repeat=false { spawn "${pkgs.pamixer}/bin/pamixer" "-t"; }
        XF86AudioPlay ${locked} repeat=false { spawn "${pkgs.playerctl}/bin/playerctl" "play-pause"; }
        XF86AudioPause ${locked} repeat=false { spawn "${pkgs.playerctl}/bin/playerctl" "play-pause"; }
        XF86AudioNext ${locked} repeat=false { spawn "${pkgs.playerctl}/bin/playerctl" "next"; }
        XF86AudioPrev ${locked} repeat=false { spawn "${pkgs.playerctl}/bin/playerctl" "previous"; }
    }
  '';

  # Fail the build, not the session, on a config error.
  validatedConfig = pkgs.runCommand "niri-config.kdl" { nativeBuildInputs = [ niri ]; } ''
    niri validate --config ${configKdl}
    cp ${configKdl} $out
  '';
in
{

  config = lib.mkIf osConfig.my.desktops.niri.enable {

    xdg.configFile."niri/config.kdl".source = validatedConfig;

    # Scratchpad helper (./scratchd.sh): keeps the stash behind your
    # workspaces, so the numbers in the bar match SUPER+<n>, and makes new
    # scratchpad windows opaque.
    systemd.user.services.niri-scratchd = {
      Unit = {
        Description = "niri scratchpad helper";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = lib.getExe (
          pkgs.writeShellApplication {
            name = "niri-scratchd";
            runtimeInputs = [
              niri
              pkgs.jq
            ];
            text = ''
              scratchpads_json=${scratchpadsJson}
            ''
            + builtins.readFile ./scratchd.sh;
          }
        );
        Restart = "always";
        RestartSec = 2;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

  };

}
