{
  pkgs,
  cfg,
  lib,
  ...
}:

let
  inherit (lib.generators) mkLuaInline;

  # Each top-level `settings.<name>` becomes one or more `hl.<name>(...)` calls.
  # Lists generate one call per element. `_args` entries become multi-arg calls,
  # and `mkLuaInline` values are emitted as raw Lua (needed for dispatchers,
  # which are function calls rather than data).

  # hl.bind(keys, dispatcher [, opts])
  bind = keys: dispatcher: {
    _args = [
      keys
      (mkLuaInline dispatcher)
    ];
  };
  bindO = keys: dispatcher: opts: {
    _args = [
      keys
      (mkLuaInline dispatcher)
      opts
    ];
  };

  # hl.env(name, value)
  envVar = name: value: {
    _args = [
      name
      value
    ];
  };

  # hl.curve(name, spec)
  curve = name: spec: {
    _args = [
      name
      (mkLuaInline spec)
    ];
  };

  # 60% × 80% floating + centered window rule for a class regex.
  floatingCentered = name: classRegex: {
    inherit name;
    match.class = classRegex;
    float = true;
    size = [
      "monitor_w * 0.6"
      "monitor_h * 0.8"
    ];
    center = true;
  };

  # Floating panel anchored to the top-right corner (tray control apps).
  # Percentages keep it scale-independent; 2% top clears the waybar.
  floatingTopRight = name: classRegex: {
    inherit name;
    match.class = classRegex;
    float = true;
    size = [
      "monitor_w * 0.33"
      "monitor_h * 0.55"
    ];
    move = [
      "monitor_w * 0.66"
      "monitor_h * 0.03"
    ];
  };

  # Slack scratchpad: if a Slack window exists, toggle its special workspace
  # (show/hide); otherwise launch it. The window_rule below routes Slack to
  # special:slack non-silently, so the first launch reveals it automatically.
  slackScratchpad = pkgs.writeShellScript "slack-scratchpad" ''
    if ${pkgs.hyprland}/bin/hyprctl clients -j \
      | ${pkgs.jq}/bin/jq -e 'any(.[]; .class | test("(?i)^slack$"))' >/dev/null; then
      ${pkgs.hyprland}/bin/hyprctl dispatch togglespecialworkspace slack
    else
      slack >/dev/null 2>&1 &
    fi
  '';

  # Super + 1..5 → focus workspace N; Super + Shift + 1..5 → move window to N.
  workspaceBinds =
    lib.concatMap
      (n: [
        (bind "SUPER + ${toString n}" "hl.dsp.focus({ workspace = ${toString n} })")
        (bind "SUPER + SHIFT + ${toString n}" "hl.dsp.window.move({ workspace = ${toString n} })")
      ])
      [
        1
        2
        3
        4
        5
      ];
in
{

  wayland.windowManager.hyprland = {
    enable = true;
    # Use the system-installed hyprland (programs.hyprland in modules/hyprland.nix).
    # Avoids a duplicate hyprland in home.packages and prevents pkgs.xwayland
    # from being pulled into the user env, which collides with turbovnc's
    # share/man/man1/Xserver.1.gz.
    package = null;
    portalPackage = null;
    xwayland.enable = false;
    systemd.enable = true;

    # Lua config (hyprland.lua). hyprlang is deprecated as of Hyprland 0.55.
    configType = "lua";

    # Workspace overview plugin disabled — hyprlandPlugins.hyprspace in
    # nixpkgs 26.05 fails to build against the current pkgs.hyprland (header
    # path mismatch). To re-enable, add `hyprwm/hyprland-plugins` as a flake
    # input and match the system hyprland to the plugin flake's hyprland.
    plugins = [ ];

    settings = {

      # hl.monitor(...) — one per entry. Scale 1.25 matches the FW16 panel.
      monitor = [
        {
          output = "eDP-1";
          mode = "highrr";
          position = "auto";
          scale = 1.25;
        }
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1.25;
        }
      ];

      # hl.config({...}) — all the static "look and feel" settings.
      config = {
        general = {
          gaps_in = 5;
          gaps_out = 8;
          border_size = 1;
          resize_on_border = true;
          col = {
            active_border = "rgb(9cb9dd)";
            inactive_border = "rgb(131d2b)";
          };
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 4;
            passes = 4;
            new_optimizations = true;
            noise = 0.02;
            ignore_opacity = true;
            popups = true;
          };
        };

        animations.enabled = true;

        dwindle.preserve_split = true;

        misc = {
          disable_hyprland_logo = true;
          vrr = 1;
        };

        input = {
          kb_layout = "us,ru";
          kb_variant = ",phonetic";
          kb_options = "grp:win_space_toggle";
          numlock_by_default = true;
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
            scroll_factor = 0.2;
          };
        };

        xwayland.force_zero_scaling = true;
      };

      # hl.curve(name, {...}) — bezier control points {x,y} pairs.
      curve = [
        (curve "easeInOut" "{ type = \"bezier\", points = { { 0.42, 0.0 }, { 0.58, 1.0 } } }")
        (curve "overshot" "{ type = \"bezier\", points = { { 0.05, 0.9 }, { 0.1, 1.1 } } }")
      ];

      # hl.animation({...}) — leaf/speed/curve. Ported from the old hyprlang block.
      animation = [
        {
          leaf = "windows";
          enabled = true;
          speed = 3;
          bezier = "overshot";
          style = "slide top";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 3;
          bezier = "overshot";
          style = "slide top";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 3;
          bezier = "overshot";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 3;
          bezier = "easeInOut";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 3;
          bezier = "overshot";
          style = "slide";
        }
        {
          leaf = "specialWorkspace";
          enabled = true;
          speed = 3;
          bezier = "overshot";
          style = "slidefadevert 50%";
        }
        {
          leaf = "layersIn";
          enabled = true;
          speed = 2;
          bezier = "easeInOut";
          style = "slide";
        }
        {
          leaf = "layersOut";
          enabled = true;
          speed = 1;
          bezier = "easeInOut";
          style = "slide";
        }
      ];

      # hl.gesture({...}) — 4-finger horizontal swipe switches workspaces.
      gesture = {
        fingers = 4;
        direction = "horizontal";
        action = "workspace";
      };

      # hl.window_rule({...}). Confirm class strings with
      # `hyprctl clients | grep -E 'class|title'` while the app is open.
      window_rule = [
        (floatingCentered "ghostty" "^(com\\.mitchellh\\.ghostty)$")
        (floatingCentered "nautilus" "^(org\\.gnome\\.Nautilus|nautilus)$")
        (floatingCentered "zen" "^zen.*")
        (floatingCentered "thorium" "^[Tt]horium.*")

        # tray control panels → floating, top-right
        (floatingTopRight "pavucontrol" "^(org\\.pulseaudio\\.pavucontrol|pavucontrol)$")
        (floatingTopRight "blueman" "^(\\.blueman-manager-wrapped|blueman-manager)$")
        (floatingTopRight "nm-editor" "^(nm-connection-editor)$")

        # Slack scratchpad — lives on the special:slack workspace (toggled by
        # Super+S). Non-silent so the first launch reveals it automatically.
        {
          name = "slack";
          match.class = "^([Ss]lack)$";
          workspace = "special:slack";
          float = true;
          size = [
            "monitor_w * 0.8"
            "monitor_h * 0.8"
          ];
          move = [
            "monitor_w * 0.1"
            "monitor_h * 0.08"
          ];
        }
      ];

      # hl.bind(...) — keys, then a dispatcher (raw Lua), optionally opts.
      bind = [
        # apps
        (bind "SUPER + T" "hl.dsp.exec_cmd(\"ghostty\")")
        (bind "SUPER + F" "hl.dsp.exec_cmd(\"zen\")")
        (bind "SUPER + E" "hl.dsp.exec_cmd(\"nautilus\")")
        (bind "SUPER + S" "hl.dsp.exec_cmd(\"${slackScratchpad}\")")
        (bind "CTRL + ALT + SPACE" "hl.dsp.exec_cmd(\"vicinae toggle\")")

        # window management
        (bind "SUPER + Q" "hl.dsp.window.close()")
        (bind "SUPER + V" "hl.dsp.window.float({ action = \"toggle\" })")
        (bind "SUPER + SHIFT + V" "hl.dsp.window.fullscreen()")
        (bind "SUPER + L" "hl.dsp.exec_cmd(\"hyprlock\")")
        (bind "SUPER + SHIFT + E" "hl.dsp.exit()")

        # focus (vim keys)
        (bind "SUPER + h" "hl.dsp.focus({ direction = \"left\" })")
        (bind "SUPER + l" "hl.dsp.focus({ direction = \"right\" })")
        (bind "SUPER + k" "hl.dsp.focus({ direction = \"up\" })")
        (bind "SUPER + j" "hl.dsp.focus({ direction = \"down\" })")

        # screenshots: grim + slurp + swappy
        (bind "Print" "hl.dsp.exec_cmd([[${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -]])")
        (bind "SHIFT + Print" "hl.dsp.exec_cmd([[${pkgs.grim}/bin/grim - | ${pkgs.swappy}/bin/swappy -f -]])")

        # color picker
        (bind "CTRL + Print" "hl.dsp.exec_cmd(\"${pkgs.hyprpicker}/bin/hyprpicker -a\")")

        # mouse drag / resize ({ mouse = true })
        (bindO "SUPER + mouse:272" "hl.dsp.window.drag()" { mouse = true; })
        (bindO "SUPER + mouse:273" "hl.dsp.window.resize()" { mouse = true; })

        # volume / brightness — locked (work on lockscreen) + repeating
        (bindO "XF86AudioRaiseVolume" "hl.dsp.exec_cmd(\"${pkgs.pamixer}/bin/pamixer -i 5\")" {
          locked = true;
          repeating = true;
        })
        (bindO "XF86AudioLowerVolume" "hl.dsp.exec_cmd(\"${pkgs.pamixer}/bin/pamixer -d 5\")" {
          locked = true;
          repeating = true;
        })
        (bindO "XF86MonBrightnessUp" "hl.dsp.exec_cmd(\"${pkgs.brightnessctl}/bin/brightnessctl set 10%+\")"
          {
            locked = true;
            repeating = true;
          }
        )
        (bindO "XF86MonBrightnessDown"
          "hl.dsp.exec_cmd(\"${pkgs.brightnessctl}/bin/brightnessctl set 10%-\")"
          {
            locked = true;
            repeating = true;
          }
        )
        (bindO "XF86AudioMute" "hl.dsp.exec_cmd(\"${pkgs.pamixer}/bin/pamixer -t\")" {
          locked = true;
        })
      ]
      ++ workspaceBinds;

      # hl.env(name, value)
      env = [
        (envVar "XCURSOR_THEME" cfg.gtktheme.cursor.interface)
        (envVar "XCURSOR_SIZE" "32")
        (envVar "GDK_BACKEND" "wayland,x11")
        (envVar "QT_QPA_PLATFORM" "wayland;xcb")
        (envVar "SDL_VIDEODRIVER" "wayland")
        (envVar "CLUTTER_BACKEND" "wayland")
        (envVar "ELECTRON_OZONE_PLATFORM_HINT" "auto")
      ];
    };

    # Startup programs. The module already emits an hl.on("hyprland.start", …)
    # for the systemd activation + plugins; this adds a second subscriber for
    # our own autostart (subscribers stack, they don't conflict).
    extraConfig = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("${pkgs.networkmanagerapplet}/bin/nm-applet --indicator")
        hl.exec_cmd("${pkgs.blueman}/bin/blueman-applet")
        hl.exec_cmd([[${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store]])
        hl.exec_cmd("systemctl --user start hyprpolkitagent")
        -- hyprpaper 0.8.4's config-file wallpaper assignment is broken; drive it
        -- over IPC once the compositor is up. The sleep avoids binding before
        -- hyprpaper finishes loading the image (which flickers).
        hl.exec_cmd([[${pkgs.bash}/bin/bash -c 'sleep 2; for m in $(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r ".[].name"); do ${pkgs.hyprland}/bin/hyprctl hyprpaper wallpaper "$m,${cfg.gtktheme.wallpaper}"; done']])
      end)
    '';

  };

}
