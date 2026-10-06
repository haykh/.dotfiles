{
  lib,
  pkgs,
  inputs,
  ...
}:

# Workspace overview (expose) via the hyprexpo plugin. Built against our locked
# Hyprland input (the flake input follows it), so the ABI always matches.
#
#   SUPER+W            toggle the overview
#   4-finger swipe up  open the overview (follows the fingers); swipe down
#                      while it is open to close it without switching
#   in the overview    click a workspace, or h/j/k/l + Return; Escape cancels

let
  lua = lib.generators.toLua { };
  hyprexpo = inputs.hyprexpo.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo;
in
{

  # Loaded with hl.plugin.load rather than `plugins` (which HM turns into
  # `hyprctl plugin load` on startup): the declarative load makes Hyprland
  # reload the config once the plugin is in, so hl.plugin.hyprexpo exists on
  # that second pass. The load must be declared on every pass, outside the
  # check, or Hyprland unloads it again.
  wayland.windowManager.hyprland.extraConfig = lib.mkAfter ''
    ------------------
    ---- HYPREXPO ----
    ------------------

    hl.plugin.load(${lua "${hyprexpo}/lib/libhyprexpo.so"})

    local function hyprexpoLoaded()
      for _, p in ipairs(hl.get_loaded_plugins()) do
        if p.name == "hyprexpo" then
          return true
        end
      end
      return false
    end

    if hyprexpoLoaded() then
      hl.config({
        plugin = {
          hyprexpo = {
            columns = 3,
            gaps_in = 5,
            gaps_out = 0,
            bg_col = "rgb(131d2b)",
            workspace_method = "center current",
            gesture_distance = 300,
            cancel_key = "escape",
            keynav_enable = 1,
          },
        },
      })

      hl.bind("SUPER + W", function() hl.plugin.hyprexpo.expo("toggle") end)

      hl.plugin.hyprexpo.gesture({ fingers = 4, direction = "up", action = "expo" })
      hl.plugin.hyprexpo.gesture({ fingers = 4, direction = "down", action = "cancel" })

      -- Entered automatically while the overview is open (keynav_enable).
      hl.define_submap("hyprexpo", function()
        hl.bind("h", function() hl.plugin.hyprexpo.kb_focus("left") end)
        hl.bind("l", function() hl.plugin.hyprexpo.kb_focus("right") end)
        hl.bind("k", function() hl.plugin.hyprexpo.kb_focus("up") end)
        hl.bind("j", function() hl.plugin.hyprexpo.kb_focus("down") end)
        hl.bind("return", function() hl.plugin.hyprexpo.kb_confirm() end)
        hl.bind("escape", function() hl.plugin.hyprexpo.expo("cancel") end)
      end)
    end
  '';

}
