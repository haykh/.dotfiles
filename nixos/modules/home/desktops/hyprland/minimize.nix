{ lib, ... }:

# Window minimize for Hyprland, which has no native minimize: windows are
# parked on the hidden special:minimized workspace and listed in the Noctalia
# bar by a local plugin (./minimize).
#
#   SUPER+X        minimize the focused window (or restore it, if it is one of
#                  the minimized windows shown by SUPER+SHIFT+X)
#   SUPER+SHIFT+X  toggle an overlay showing all minimized windows
#   bar icon click restore that window, floating and centered, onto the
#                  current workspace
#
# Apps asking to be minimized themselves (window.minimize) are parked too.

{

  # Appended after ./hyprland.nix's config. `Minimize` is global so the bar
  # widget can call it with `hyprctl eval 'Minimize.restore("0x...")'`.
  wayland.windowManager.hyprland.extraConfig = lib.mkAfter ''
    ------------------
    ---- MINIMIZE ----
    ------------------

    Minimize = {}
    local minimizedWs = "special:minimized"

    local function minimizedWindows()
      return hl.get_windows({ workspace = minimizedWs })
    end

    -- Tell the bar widget to re-read the minimized list. `closing` is a window
    -- that is still listed but about to go away, for the widget to skip.
    local function refreshBar(closing)
      hl.exec_cmd("noctalia msg plugin hayk/minimized:minimized all refresh " .. (closing or ""))
    end

    local function overlayOpen()
      local special = hl.get_active_special_workspace()
      return special ~= nil and special.name == minimizedWs
    end

    function Minimize.minimize(w)
      w = w or hl.get_active_window()
      if w == nil then
        return
      end
      local ws = hl.get_active_workspace()
      hl.dispatch(hl.dsp.window.move({ workspace = minimizedWs, window = "address:" .. w.address, follow = false }))
      -- Focus stays on the hidden window otherwise; hand it to the most
      -- recently focused window left on this workspace.
      local next
      for _, c in ipairs(hl.get_windows({ workspace = ws.id })) do
        if c.address ~= w.address and (next == nil or c.focus_history_id < next.focus_history_id) then
          next = c
        end
      end
      if next ~= nil then
        hl.dispatch(hl.dsp.focus({ window = "address:" .. next.address }))
      end
    end

    function Minimize.restore(address)
      local sel = "address:" .. address
      local w = hl.get_window(sel)
      if w == nil then
        return
      end
      -- Close the overlay first so the window lands on the regular workspace.
      if overlayOpen() then
        hl.dispatch(hl.dsp.workspace.toggle_special("minimized"))
      end
      local wasFloating = w.floating
      hl.dispatch(hl.dsp.window.move({ workspace = hl.get_active_workspace().id, window = sel, follow = false }))
      hl.dispatch(hl.dsp.window.float({ action = "enable", window = sel }))
      hl.dispatch(hl.dsp.focus({ window = sel }))
      -- A window that was tiled keeps its tile size when floated; give it the
      -- same 60%x80% as the other floating rules instead.
      if not wasFloating then
        local m = hl.get_active_monitor()
        hl.dispatch(hl.dsp.window.resize({ x = m.width / m.scale * 0.6, y = m.height / m.scale * 0.8 }))
      end
      hl.dispatch(hl.dsp.window.center())
    end

    function Minimize.toggle()
      local w = hl.get_active_window()
      if w == nil then
        return
      end
      if hl.get_window("address:" .. w.address).workspace.name == minimizedWs then
        Minimize.restore(w.address)
      else
        Minimize.minimize(w)
      end
    end

    function Minimize.show()
      -- Don't open an empty overlay.
      if overlayOpen() or #minimizedWindows() > 0 then
        hl.dispatch(hl.dsp.workspace.toggle_special("minimized"))
      end
    end

    hl.bind("SUPER + X", Minimize.toggle)
    hl.bind("SUPER + SHIFT + X", Minimize.show)

    -- Minimize requests from apps (e.g. a client-side titlebar button).
    hl.on("window.minimize", function(w, minimized)
      if w ~= nil and minimized ~= false then
        Minimize.minimize(w)
      end
    end)

    -- Keep the bar in sync with every way a window enters or leaves the
    -- minimized workspace (our dispatches above included). `parked` tracks
    -- the minimized windows so unrelated moves don't spawn a refresh.
    local parked = {}
    for _, w in ipairs(minimizedWindows()) do
      parked[w.address] = true
    end

    hl.on("window.move_to_workspace", function(w, ws)
      if ws.name == minimizedWs then
        parked[w.address] = true
        refreshBar()
      elseif parked[w.address] then
        parked[w.address] = nil
        refreshBar()
      end
    end)

    hl.on("window.close", function(w)
      if parked[w.address] then
        parked[w.address] = nil
        refreshBar(w.address)
      end
    end)
  '';

  # Noctalia scans ~/.local/share/noctalia/plugins as an implicit "local"
  # plugin source. Enabled and placed in the bar in ./noctalia.nix.
  xdg.dataFile."noctalia/plugins/minimized".source = ./minimize;

}
