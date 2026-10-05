{
  pkgs,
  cfg,
  lib,
  ...
}:

let
  # Nix value -> Lua literal (strings are JSON-escaped, which Lua accepts).
  lua = lib.generators.toLua { };

  # Internal panel. The connector name flips between eDP-1 and eDP-2 depending
  # on GPU enumeration order, so match it by EDID description instead.
  internalPanel = "desc:BOE 0x0BC9";

  screenshotCmd =
    grimArgs:
    ''${pkgs.grim}/bin/grim ${grimArgs} - | ${pkgs.satty}/bin/satty -f - --copy-command ${pkgs.wl-clipboard}/bin/wl-copy --output-filename "$HOME/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png"'';

  # Window rules, rendered as hl.window_rule({ ... }) calls.
  floatCenter = name: class: {
    inherit name;
    match = { inherit class; };
    float = true;
    size = "monitor_w*0.6 monitor_h*0.8";
    center = true;
  };
  floatCenterTitled = name: title: class: {
    inherit name;
    match = { inherit class title; };
    float = true;
    size = "monitor_w*0.6 monitor_h*0.8";
    center = true;
  };
  floatCenterDialog = name: class: title: {
    inherit name;
    match = { inherit class title; };
    float = true;
    center = true;
  };
  topRight = name: class: {
    inherit name;
    match = { inherit class; };
    float = true;
    size = "monitor_w*0.33 monitor_h*0.55";
    move = "monitor_w*0.66 monitor_h*0.03";
  };
  pictureInPicture = name: title: class: {
    inherit name;
    match = { inherit class title; };
    pin = true;
    float = true;
    size = "monitor_w*0.25 monitor_h*0.27";
    move = "monitor_w*0.74 monitor_h*0.04";
  };
  specialWorkspace = name: match: {
    inherit name match;
    workspace = "special:${name}";
    float = true;
    size = "monitor_w*0.8 monitor_h*0.85";
  };

  windowRules = [
    (floatCenter "ghostty" "^(com\\.mitchellh\\.ghostty)$")
    (floatCenter "zen" "^zen.*")
    (floatCenter "thorium" "^[Tt]horium.*")
    (floatCenter "satty" "com.gabm.satty")
    (floatCenter "oculante" "oculante")
    (floatCenter "zathura" "org.pwmt.zathura")
    (floatCenter "text-editor" "org.gnome.TextEditor")
    (floatCenter "mpv" "mpv")
    (floatCenter "wolfram" "^(com.wolfram.Wolfram\\..*)")

    (floatCenterTitled "thunar" "^(.* - Thunar)$" "^([Tt]hunar)$")
    (floatCenterDialog "thunar-progress" "^([Tt]hunar)$" "^(File Operation Progress)$")
    (floatCenterDialog "thunar-rename" "^([Tt]hunar)$" "^(Rename.*)$")
    (floatCenterDialog "thunar-confirm-replace" "^([Tt]hunar)$" "^(Confirm to replace files)$")
    (floatCenterDialog "thunar-attention" "^([Tt]hunar)$" "^(Attention)$")
    (floatCenterDialog "thunar-properties" "^([Tt]hunar)$" "^(.*Properties)$")
    (floatCenterDialog "thunar-create" "^([Tt]hunar)$" "^(Create.*)$")
    (floatCenterDialog "thunar-trash" "^([Tt]hunar)$" "^(Trash)$")
    (floatCenterDialog "thunar-auth" "^([Tt]hunar)$" "^(Authentication)$")

    (pictureInPicture "pip" "Picture-in-Picture" "zen")

    (topRight "pavucontrol" "^(org\\.pulseaudio\\.pavucontrol|pavucontrol)$")
    (topRight "blueman" "^(\\.blueman-manager-wrapped|blueman-manager)$")
    (topRight "nm-editor" "^(nm-connection-editor)$")

    (specialWorkspace "slack" { class = "^([Ss]lack)$"; })
    (specialWorkspace "telegram" { class = "^(org\\.telegram\\.desktop)$"; })
    (specialWorkspace "tidal" { class = "^(tidal-hifi)$"; })
    (specialWorkspace "filen" {
      class = "electron";
      title = "^(Filen)$";
    })
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

    # Lua config (Hyprland >= 0.56). Note that `hyprctl dispatch` then takes Lua
    # (`hyprctl dispatch 'hl.dsp.focus({ workspace = 2 })'`), not the old
    # `dispatch workspace 2` syntax; `hyprctl keyword` is gone (use `eval`).
    # Noctalia detects the Lua config and sends hl.dsp.* dispatches itself.
    configType = "lua";

    plugins = [ ];

    # Written as plain Lua rather than via `settings`: HM renders `settings`
    # sections alphabetically, which would put hl.animation before hl.curve.
    extraConfig = ''
      ------------------
      ---- MONITORS ----
      ------------------

      local internalPanel = ${lua internalPanel}
      local internalMode = { output = internalPanel, mode = "highrr", position = "auto", scale = "1.25" }

      hl.monitor(internalMode)
      -- Desk Dells (same model, so match by serial). Positions are in logical
      -- px: 3840 / 1.25 = 3072, so the right one starts at x=3072.
      hl.monitor({ output = "desc:Dell Inc. DELL U3223QE CTS50P3", mode = "highres", position = "0x0", scale = "1.25" })
      hl.monitor({ output = "desc:Dell Inc. DELL U3223QE GMJJXN3", mode = "highres", position = "3072x0", scale = "1.25" })
      -- highres = max resolution, then max refresh rate at that resolution.
      -- `preferred` would follow the EDID, which often advertises 60Hz.
      hl.monitor({ output = "", mode = "highres", position = "auto", scale = "1.25" })

      ---------------------
      ---- ENVIRONMENT ----
      ---------------------

      hl.env("XCURSOR_THEME", ${lua cfg.theme.cursor.interface})
      hl.env("XCURSOR_SIZE", "32")
      hl.env("GDK_BACKEND", "wayland,x11")
      hl.env("QT_QPA_PLATFORM", "wayland;xcb")
      hl.env("SDL_VIDEODRIVER", "wayland")
      hl.env("CLUTTER_BACKEND", "wayland")
      hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

      -------------------
      ---- AUTOSTART ----
      -------------------

      hl.on("hyprland.start", function()
        hl.exec_cmd(${lua "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"})
        hl.exec_cmd(${lua "${pkgs.blueman}/bin/blueman-applet"})
        hl.exec_cmd(${lua "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store"})
        hl.exec_cmd("systemctl --user start hyprpolkitagent")
        hl.exec_cmd("uwsm app -- noctalia")
      end)

      -----------------------
      ---- LOOK AND FEEL ----
      -----------------------

      hl.config({
        general = {
          gaps_in = 5,
          gaps_out = 8,
          border_size = 1,
          resize_on_border = true,
          col = {
            active_border = "rgb(9cb9dd)",
            inactive_border = "rgb(131d2b)",
          },
          layout = "dwindle",
        },

        decoration = {
          rounding = 10,
          blur = {
            enabled = true,
            size = 4,
            passes = 4,
            new_optimizations = true,
            noise = 0.02,
            ignore_opacity = true,
            popups = true,
          },
        },

        animations = {
          enabled = true,
        },

        dwindle = {
          preserve_split = true,
        },

        misc = {
          disable_hyprland_logo = true,
          vrr = 1,
        },

        cursor = {
          -- Hardware cursors live on a separate display-controller overlay plane
          -- and never enter the framebuffer, so PipeWire/xdg-portal screen capture
          -- (Zoom, OBS, etc.) records without the cursor. `2` = auto: keep hardware
          -- cursors normally, fall back to a software cursor only while a screencast
          -- is active — so the cursor shows up in shares without a perf cost the
          -- rest of the time. Set to `true` if a share still drops the cursor.
          no_hardware_cursors = 2,
        },

        input = {
          kb_layout = "us,ru",
          kb_variant = ",phonetic",
          kb_options = "grp:win_space_toggle",
          numlock_by_default = true,
          follow_mouse = 1,
          touchpad = {
            natural_scroll = true,
            scroll_factor = 0.2,
          },
        },

        xwayland = {
          force_zero_scaling = true,
        },
      })

      hl.curve("easeInOut", { type = "bezier", points = { { 0.42, 0.0 }, { 0.58, 1.0 } } })
      hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.1 } } })
      hl.curve("wspaceSlide", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })

      hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "overshot", style = "slide top" })
      hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "overshot", style = "slide top" })
      hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "overshot" })
      hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "easeInOut" })
      hl.animation({ leaf = "workspaces", enabled = true, speed = 3, bezier = "wspaceSlide", style = "slide" })
      hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "overshot", style = "slidefadevert 50%" })
      hl.animation({ leaf = "layersIn", enabled = true, speed = 2, bezier = "easeInOut", style = "fade" })
      hl.animation({ leaf = "layersOut", enabled = true, speed = 1, bezier = "easeInOut", style = "fade" })

      hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })

      -------------------
      ---- FUNCTIONS ----
      -------------------

      -- Toggle the app's special workspace if it is running, otherwise launch it.
      local function scratchpad(name, matches, cmd)
        return function()
          for _, w in ipairs(hl.get_windows()) do
            if matches(w) then
              hl.dispatch(hl.dsp.workspace.toggle_special(name))
              return
            end
          end
          hl.dispatch(hl.dsp.exec_cmd(cmd))
        end
      end

      local function hasInternal()
        for _, m in ipairs(hl.get_monitors()) do
          if m.name:find("^eDP") then
            return true
          end
        end
        return false
      end

      local function hasExternal()
        for _, m in ipairs(hl.get_monitors()) do
          if not m.name:find("^eDP") then
            return true
          end
        end
        return false
      end

      -- Lid handlers. Only blank the internal panel when an external monitor is
      -- connected (dock mode). If the panel is the sole output we must NOT disable
      -- it — doing so leaves Hyprland with no output as logind suspends and the
      -- panel fails to relight on resume. In that case do nothing and let logind
      -- suspend.
      local function lidClose()
        if hasExternal() then
          hl.monitor({ output = internalPanel, disabled = true })
        end
      end

      -- Re-enable the panel on open only if it is currently off (i.e. we disabled
      -- it for dock mode). This keeps a normal suspend/resume from re-initialising
      -- the output, which can retrigger the amdgpu DCN resume glitch.
      local function lidOpen()
        if not hasInternal() then
          hl.monitor(internalMode)
        end
      end

      -- Resize the active window to 90% of the monitor (logical px) and center it.
      local function bigCenter()
        local m = hl.get_active_monitor()
        hl.dispatch(hl.dsp.window.resize({ x = m.width / m.scale * 0.9, y = m.height / m.scale * 0.9 }))
        hl.dispatch(hl.dsp.window.center())
      end

      ---------------
      ---- BINDS ----
      ---------------

      -- apps
      hl.bind("SUPER + T", hl.dsp.exec_cmd("ghostty"))
      hl.bind("SUPER + F", hl.dsp.exec_cmd("zen"))
      hl.bind("SUPER + E", hl.dsp.exec_cmd("thunar"))
      hl.bind("SUPER + S", scratchpad("slack", function(w) return w.class:lower() == "slack" end, "slack"))
      hl.bind("SUPER + G", scratchpad("telegram", function(w) return w.class == "org.telegram.desktop" end, "Telegram"))
      hl.bind("SUPER + M", scratchpad("tidal", function(w) return w.class == "tidal-hifi" end, "tidal-hifi"))
      hl.bind("SUPER + D", scratchpad("filen", function(w) return w.class == "electron" and w.title == "Filen" end, "filen-desktop"))
      hl.bind("CTRL + ALT + SPACE", hl.dsp.exec_cmd("vicinae toggle"))

      -- window management
      hl.bind("SUPER + Q", hl.dsp.window.close())
      hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind("SUPER + SHIFT + V", hl.dsp.window.fullscreen())
      hl.bind("SUPER + equal", bigCenter)
      hl.bind("SUPER + L", hl.dsp.exec_cmd("noctalia msg session lock"))
      hl.bind("SUPER + SHIFT + E", hl.dsp.exit())

      -- focus (vim keys)
      hl.bind("CTRL + SHIFT + H", hl.dsp.focus({ direction = "left" }))
      hl.bind("CTRL + SHIFT + L", hl.dsp.focus({ direction = "right" }))
      hl.bind("CTRL + SHIFT + K", hl.dsp.focus({ direction = "up" }))
      hl.bind("CTRL + SHIFT + J", hl.dsp.focus({ direction = "down" }))

      -- workspaces
      for i = 1, 9 do
        hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
        hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
      end

      -- screenshots
      hl.bind("Print", hl.dsp.exec_cmd(${lua (screenshotCmd ''-g "$(${pkgs.slurp}/bin/slurp)"'')}))
      hl.bind("SHIFT + Print", hl.dsp.exec_cmd(${lua (screenshotCmd "")}))

      -- color picker
      hl.bind("CTRL + Print", hl.dsp.exec_cmd(${lua "${pkgs.hyprpicker}/bin/hyprpicker -a"}))

      -- SUPER+left moves, SUPER+right resizes (mouse), SUPER+SHIFT+left resizes
      -- (the trackpad-friendly variant — holding right + dragging is awkward).
      hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
      hl.bind("SUPER + SHIFT + mouse:272", hl.dsp.window.resize(), { mouse = true })

      -- volume / brightness — locked (work on lockscreen) + repeating
      local lockedRepeat = { locked = true, repeating = true }
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(${lua "${pkgs.pamixer}/bin/pamixer -i 5"}), lockedRepeat)
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(${lua "${pkgs.pamixer}/bin/pamixer -d 5"}), lockedRepeat)
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(${lua "${pkgs.brightnessctl}/bin/brightnessctl set 10%+"}), lockedRepeat)
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(${lua "${pkgs.brightnessctl}/bin/brightnessctl set 10%-"}), lockedRepeat)

      -- Lid: turn the internal panel off on close, back on when opened.
      -- logind treats an external monitor as "docked" (HandleLidSwitchDocked
      -- defaults to ignore), so with a monitor connected the machine won't
      -- suspend — this just blanks the internal panel. With no external monitor, logind
      -- still suspends per services.logind, so the panel returns on resume.
      -- Device name comes from `hyprctl devices` (usually "Lid Switch").
      local locked = { locked = true }
      hl.bind("switch:on:Lid Switch", lidClose, locked)
      hl.bind("switch:off:Lid Switch", lidOpen, locked)

      hl.bind("XF86AudioMute", hl.dsp.exec_cmd(${lua "${pkgs.pamixer}/bin/pamixer -t"}), locked)
      -- media keys (MPRIS via playerctl) — locked so they work on lockscreen
      hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(${lua "${pkgs.playerctl}/bin/playerctl play-pause"}), locked)
      hl.bind("XF86AudioPause", hl.dsp.exec_cmd(${lua "${pkgs.playerctl}/bin/playerctl play-pause"}), locked)
      hl.bind("XF86AudioNext", hl.dsp.exec_cmd(${lua "${pkgs.playerctl}/bin/playerctl next"}), locked)
      hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(${lua "${pkgs.playerctl}/bin/playerctl previous"}), locked)

      ---------------
      ---- RULES ----
      ---------------

      ${lib.concatMapStringsSep "\n" (rule: "hl.window_rule(${lua rule})") windowRules}

      hl.layer_rule(${
        lua {
          name = "noctalia";
          match.namespace = "noctalia-background-.*$";
          ignore_alpha = 0.5;
          blur = true;
          blur_popups = true;
        }
      })
    '';

  };

}
