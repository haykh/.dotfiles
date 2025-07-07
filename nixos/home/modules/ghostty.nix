{ pkgs, ... }:

{

  enableZshIntegration = true;
  package = pkgs.ghostty.overrideAttrs (_: {
    preBuild = ''
      shopt -s globstar
      sed -i 's/^const xev = @import("xev");$/const xev = @import("xev").Epoll;/' **/*.zig
      shopt -u globstar
    '';
  });
  settings = {
    theme = "GitHub-Dark-Default";
    font-family = "MonaspiceKr Nerd Font";
    font-family-italic = "MonaspiceRn Nerd Font";
    font-style-italic = "MonaspiceRn NF";
    cursor-invert-fg-bg = true;
    cursor-opacity = 0.75;
    window-decoration = "none";
    background-opacity = 0.9;
    background-blur = true;
    keybind = [
      "ctrl+shift+|=new_split:right"
      "ctrl+shift+-=new_split:down"
      "ctrl+shift+]=goto_split:right"
      "ctrl+shift+[=goto_split:left"
      "super+w=toggle_tab_overview"
    ];
  };

}
