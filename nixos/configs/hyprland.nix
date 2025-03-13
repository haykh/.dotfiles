{ pkgs, ... }:

{

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      pkgs.hyprlandPlugins.hyprexpo
    ];
    settings = {
      # startup
      exec-once = [
        "hyprpm enable hyprexpo"
      ];
      env = [
        # Env variables
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "XDG_CACHE_HOME,$HOME/.cache"
        # "XCURSOR_SIZE,16"

        "ELECTRON_OZONE_PLATFORM_HINT,auto"

        # gtk
        "GDK_SCALE,1.25"
        "GDK_BACKEND,wayland"

        # qt
        "QT_QPA_PLATFORM,wayland;xcb"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
        # "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      ];

      monitor = [
        "eDP-2, highrr, auto, 1.25, bitdepth, 10"
        "DP-1, preferred, auto-up, 2.0"
      ];

      input = {
        kb_layout = "us, ru";
        kb_variant = ", phonetic";
        kb_model = "";
        kb_options = "grp:win_space_toggle";
        kb_rules = "";
        numlock_by_default = true;

        follow_mouse = true;

        touchpad = {
          natural_scroll = "yes";
          scroll_factor = 0.2;
        };
        # -1.0 ... 1.0, 0 means no modification.
        sensitivity = 0;
      };

      general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        gaps_in = 5;
        gaps_out = 8;
        border_size = 1;
        resize_on_border = true;
        allow_tearing = false;

        "col.active_border" = "rgb(9cb9dd)";
        "col.inactive_border" = "rgb(131D2B)";

        layout = "dwindle";
      };

      animations = {
        enabled = "yes";

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
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
          "layersIn, 1, 2, easeInOut, slide"
          "layersOut, 1, 1, easeInOut, slide"
        ];
      };

      decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

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

        layerrule = [
          "blur, logout_dialog"
          "animation fade, logout_dialog"
          "blur, rofi"
          "ignorezero, rofi"
          "animation fade, rofi"
          "unset, notifications"
          "blur, notifications"
          "ignorezero, notifications"
          "animation slide right, notifications"
          "animation fade, selection"
          "animation fade, hyprpicker"
        ];

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      xwayland = {
        force_zero_scaling = true;
      };

      dwindle = {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = "yes";
        preserve_split = "yes";
      };

      master = {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
      };

      gestures = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = "on";
        workspace_swipe_fingers = 4;
      };

      misc = {
        vrr = 1;
        disable_hyprland_logo = "yes";
      };

      # Keybindings
      "$mod" = "SUPER";
      bind =
        [
          "$mod, W, hyprexpo:expo, toggle" # can be: toggle, off/disable or on/enable
          # Window cycle
          "$mod, Tab, cyclenext"
          "$mod, Tab, bringactivetotop"
          "$mod SHIFT, Tab, cyclenext, prev"
          "$mod SHIFT, Tab, bringactivetotop"

          # Window manipulation
          "$mod, V, togglefloating,"
          "$mod SHIFT, V, fullscreen,"
          "$mod SHIFT, P, pin,"
          "$mod, Q, killactive,"

          # Move focus with mainMod + arrow keys
          "$mod, left, movefocus, l"
          "$mod, right, movefocus, r"
          "$mod, up, movefocus, u"
          "$mod, down, movefocus, d"

          # Apps
          "$mod, F, exec, librewolf"
          "$mod, T, exec, ghostty"

          # Workspaces
          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
          "$mod, code:112, workspace, e+1"
          "$mod, code:117, workspace, e-1"
        ]
        ++
          # Workspace switch (press 0 for 10)
          builtins.map (i: "$mod, ${toString (if i == 10 then 0 else i)}, workspace, ${toString i}") (
            pkgs.lib.lists.range 1 10
          )
        ++ builtins.map (
          i: "$mod SHIFT, ${toString (if i == 10 then 0 else i)}, movetoworkspace, ${toString i}"
        ) (pkgs.lib.lists.range 1 10);
      bindm = [
        # Moving windows
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      binde = [
        # Resize/reposition windows
        "$mod, code:20, resizeactive, exact 40% 40%"
        "$mod, code:20, centerwindow, "
        "$mod, code:21, resizeactive, exact 80% 80%"
        "$mod, code:21, centerwindow,"
      ];
      bindl = [
        # Trigger when the switch is turning on
        " , switch:on:Lid Switch, exec, hyprctl keyword monitor \"eDP-2, disable\""
        " , switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-2, highrr, auto, 1.25\""
        # Manually disable/enable the main monitor
        "$mod SHIFT, F1, exec, $MASTERSCRIPT monitor off"
        "$mod SHIFT, F2, exec, $MASTERSCRIPT monitor on"
      ];

      windowrulev2 = [
        "float, class:^.*"

        # librewolf
        "size 60% 80%, class:^(librewolf)$ initialTitle:^(Librewolf)$"
        "center, class:^(librewolf)$ initialTitle:^(Librewolf)$"

        # thunderbird
        "size 60% 80%, class:^(betterbird.*)$ title:^((?!Sending Message).)*$"

        # kitty
        # "opacity 0.9 0.9, class:^(kitty)$"
        "size 60% 80%, class:^(kitty)$"

        # thunar
        "opacity 1 1, class:^([T|t]hunar) title:^(.*[T|t]hunar.*)$"
        "size 50% 50%, class:^([T|t]hunar) title:^(.*[T|t]hunar.*)$"

        # rofi
        "move 100%-433 53, class:^(rofi)$, title:^(clippick)$"
        "opacity 0.8 0.8, class:(rofi)"

        # amdgpu
        "size 80% 80%, class:^(amdgpu_top)$"

        # thorium
        "size 80% 80%, class:^(thorium)(.*)$"
        "opacity 0.85 0.85, class:^(thorium-calendar)(.*)$"

        # pip
        "size 30% 30%, title:^(Picture in picture)$"
        "move 68% 68%, title:^(Picture in picture)$"
        "pin, title:^(Picture in picture)$"

        # slack
        "workspace special:ws_slack, class:^(Slack)$"
        "size 80% 80%, class:^(Slack)$"
        "move 0% 10%, class:^(Slack)$"

        # jabref
        "size 60% 70%, class:^(.*org\.jabref.*)$"
        "center, class:^(.*org\.jabref.*)$"

        # music
        "workspace special:ws_music, class:^(tidal-hifi)$"
        "size 75% 80%, class:^(tidal-hifi)$"
        "move 25% 10%, class:^(tidal-hifi)$"
        "opacity 0.8 0.8, class:^(tidal-hifi)$"
      ];
      bindd = [
        "$mod SHIFT, Q, Exit Hyprland, exit"
      ];
    };
  };
  home.sessionVariables.NIXOS_OZONE_WL = "1";

}
