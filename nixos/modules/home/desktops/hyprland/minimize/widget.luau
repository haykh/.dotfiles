--!nonstrict
-- Minimized windows bar widget. Hyprland's config (../minimize.nix) sends a
-- `refresh` IPC event whenever the minimized set changes (with the address of
-- a minimized window that is closing, if any); we then re-read the clients
-- list and render one app icon per minimized window.
-- Clicking an icon calls back into the config's global `Minimize.restore`.

local minimizedWs = "special:minimized"
local windows = {}

local function restore(address)
  noctalia.runAsync({ "hyprctl", "eval", `Minimize.restore("{address}")` })
end

local function render()
  if #windows == 0 then
    barWidget.setVisible(false)
    return
  end
  barWidget.setVisible(true)

  local items = {}
  for _, w in windows do
    local address = w.address
    local onClick = function()
      restore(address)
    end
    local icon = noctalia.appIconPath(w.class, 32)
    if icon ~= nil then
      table.insert(items, ui.image({
        key = address,
        path = icon,
        width = 20,
        height = 20,
        fit = "contain",
        tooltip = w.title,
        onClick = onClick,
      }))
    else
      table.insert(items, ui.button({
        key = address,
        glyph = "app-window",
        glyphSize = 16,
        variant = "ghost",
        tooltip = w.title,
        onClick = onClick,
      }))
    end
  end

  local container = barWidget.isVertical() and ui.column or ui.row
  barWidget.render(container({ gap = 8, align = "center" }, items))
end

local function refresh(closing)
  noctalia.runAsync({ "hyprctl", "clients", "-j" }, function(result)
    if result.exitCode ~= 0 then
      return
    end
    local clients = noctalia.json.decode(result.stdout)
    if type(clients) ~= "table" then
      return
    end
    windows = {}
    for _, c in clients do
      if c.workspace ~= nil and c.workspace.name == minimizedWs and c.address ~= closing then
        table.insert(windows, { address = c.address, class = c.class, title = c.title })
      end
    end
    -- The first appIconPath call loads the icon theme, which can blow this
    -- callback's CPU budget. The lookup still gets cached, so retry the
    -- render once in a fresh callback.
    if not pcall(render) then
      noctalia.runAsync({ "true" }, function()
        render()
      end)
    end
  end)
end

function onIpc(event, payload)
  if event == "refresh" then
    refresh(payload)
  end
end

-- Clicking the capsule outside an icon toggles the minimized overlay.
function onClick()
  noctalia.runAsync({ "hyprctl", "eval", "Minimize.show()" })
end

barWidget.setVisible(false)
refresh()
