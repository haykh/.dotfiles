{
  pkgs,
  cfg,
  lib,
  ...
}:

let
  makeScratchpad =
    appName: classRegex: launchCmd:
    pkgs.writeShellScript "scratchpad-${appName}" ''
      if ${pkgs.hyprland}/bin/hyprctl clients -j \
        | ${pkgs.jq}/bin/jq -e 'any(.[]; .class | test("(?i)${classRegex}"))' >/dev/null; then
        ${pkgs.hyprland}/bin/hyprctl dispatch togglespecialworkspace ${appName}
      else
        ${launchCmd} >/dev/null 2>&1 &
      fi
    '';

  slackScratchpad = makeScratchpad "slack" "^([Ss]lack)$" "slack";
  telegramScratchpad = makeScratchpad "telegram" "^(org.telegram.desktop)$" "Telegram";
  tidalScratchpad = makeScratchpad "tidal" "^(tidal-hifi)$" "tidal-hifi";

  # Super + 1..5 → focus workspace N; Super + Shift + 1..5 → move window to N.
  workspaceBinds =
    lib.concatMap
      (n: [
        "SUPER, ${toString n}, workspace, ${toString n}"
        "SUPER SHIFT, ${toString n}, movetoworkspace, ${toString n}"
      ])
      [
        1
        2
        3
        4
        5
      ];

  floatCenter = name: class: ''
    windowrule {
      name = ${name}
      match {
        class = ${class}
      }
      float = on
      size = (monitor_w*0.6) (monitor_h*0.8)
      center = on
    }
  '';
  topRight = name: class: ''
    windowrule {
      name = ${name}
      match {
        class = ${class}
      }
      float = on
      size = (monitor_w*0.33) (monitor_h*0.55)
      move = (monitor_w*0.66) (monitor_h*0.03)
    }
  '';
  specialWorkspace = name: class: ''
    windowrule {
      name = ${name}
      match {
        class = ${class}
      }
      float = on
      size = (monitor_w*0.8) (monitor_h*0.85)
    }
  '';
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

    # hyprlang config. NOT lua: lua configType makes Hyprland interpret the
    # dispatch IPC socket as lua, which breaks every external tool that sends
    # plain dispatches (Noctalia, scripts, `hyprctl dispatch workspace 2`, …).
    configType = "hyprlang";

    plugins = [ ];

    settings = {

      monitor = [
        "eDP-1,highrr,auto,1.25"
        ",preferred,auto,1.25"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 8;
        border_size = 1;
        resize_on_border = true;
        "col.active_border" = "rgb(9cb9dd)";
        "col.inactive_border" = "rgb(131d2b)";
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

      animations = {
        enabled = true;
        bezier = [
          "easeInOut, 0.42, 0.0, 0.58, 1.0"
          "overshot, 0.05, 0.9, 0.1, 1.1"
        ];
        animation = [
          "windows, 1, 3, overshot, slide top"
          "windowsOut, 1, 3, overshot, slide top"
          "border, 1, 3, overshot"
          "fade, 1, 3, easeInOut"
          "workspaces, 1, 3, overshot, slide"
          "specialWorkspace, 1, 3, overshot, slidefadevert 50%"
          "layersIn, 1, 2, easeInOut, fade"
          "layersOut, 1, 1, easeInOut, fade"
        ];
      };

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

      gesture = "4, horizontal, workspace";

      env = [
        "XCURSOR_THEME,${cfg.gtktheme.cursor.interface}"
        "XCURSOR_SIZE,32"
        "GDK_BACKEND,wayland,x11"
        "QT_QPA_PLATFORM,wayland;xcb"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
      ];

      exec-once = [
        "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
        "${pkgs.blueman}/bin/blueman-applet"
        "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store"
        "systemctl --user start hyprpolkitagent"
        "uwsm app -- noctalia-shell"
        # Noctalia owns the wallpaper (hyprpaper removed). Set it on every output
        # once its IPC is up (the sleep waits for startup).
        "${pkgs.bash}/bin/bash -c 'sleep 3; for m in $(${pkgs.hyprland}/bin/hyprctl monitors -j | ${pkgs.jq}/bin/jq -r \".[].name\"); do noctalia-shell ipc call wallpaper set \"${cfg.gtktheme.wallpaper}\" \"$m\"; done'"
      ];

      bind = [
        # apps
        "SUPER, T, exec, ghostty"
        "SUPER, F, exec, zen"
        "SUPER, E, exec, thunar"
        "SUPER, S, exec, ${slackScratchpad}"
        "SUPER, G, exec, ${telegramScratchpad}"
        "SUPER, M, exec, ${tidalScratchpad}"
        "CTRL ALT, SPACE, exec, vicinae toggle"

        # window management
        "SUPER, Q, killactive"
        "SUPER, V, togglefloating"
        "SUPER SHIFT, V, fullscreen"
        # Resize the (floating) active window to 90% x 90% of the monitor + center.
        "SUPER, equal, resizeactive, exact 90% 90%"
        "SUPER, equal, centerwindow"
        "SUPER, L, exec, noctalia-shell ipc call lockScreen lock"
        "SUPER SHIFT, E, exit"
        # Noctalia workspace-overview plugin (toggle via its IPC).
        "SUPER, W, exec, noctalia-shell ipc call plugin:workspace-overview toggle"

        # focus (vim keys)
        "CTRL SHIFT, H, movefocus, l"
        "CTRL SHIFT, L, movefocus, r"
        "CTRL SHIFT, K, movefocus, u"
        "CTRL SHIFT, J, movefocus, d"

        # screenshots: grim + slurp + swappy
        '', Print, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f -''
        "SHIFT, Print, exec, ${pkgs.grim}/bin/grim - | ${pkgs.swappy}/bin/swappy -f -"

        # color picker
        "CTRL, Print, exec, ${pkgs.hyprpicker}/bin/hyprpicker -a"
      ]
      ++ workspaceBinds;

      # SUPER+left moves, SUPER+right resizes (mouse), SUPER+SHIFT+left resizes
      # (the trackpad-friendly variant — holding right + dragging is awkward).
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
        "SUPER SHIFT, mouse:272, resizewindow"
      ];

      # volume / brightness — locked (work on lockscreen) + repeating
      bindel = [
        ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5"
        ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5"
        ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 10%+"
        ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 10%-"
      ];
      bindl = [
        ", XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"
      ];
    };

    extraConfig = ''
      ${floatCenter "ghostty" "^(com\\.mitchellh\\.ghostty)$"}
      ${floatCenter "thunar" "^([Tt]hunar)$"}
      ${floatCenter "zen" "^zen.*"}
      ${floatCenter "thorium" "^[Tt]horium.*"}

      ${topRight "pavucontrol" "^(org\\.pulseaudio\\.pavucontrol|pavucontrol)$"}
      ${topRight "blueman" "^(\\.blueman-manager-wrapped|blueman-manager)$"}
      ${topRight "nm-editor" "^(nm-connection-editor)$"}

      ${specialWorkspace "slack" "^([Ss]lack)$"}
      ${specialWorkspace "telegram" "^(org\\.telegram\\.desktop)$"}
      ${specialWorkspace "tidal" "^(tidal-hifi)$"}

      layerrule {
        name = noctalia
        match {
          namespace = noctalia-background-.*$
        }
        ignore_alpha = 0.5
        blur = true
        blur_popups = true
      }
    '';

  };

}
