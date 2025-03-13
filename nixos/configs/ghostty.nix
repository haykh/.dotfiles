{ ... }:

{

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "GitHub-Dark-Default";
      font-family = "MonaspiceKr Nerd Font";
      font-family-italic = "MonaspiceRn Nerd Font";
      font-style-italic = "MonaspiceRn NF";
      cursor-invert-fg-bg = true;
      cursor-opacity = 0.75;
      window-decoration = "none";
      keybind = [
        "ctrl+shift+|=new_split:right"
        "ctrl+shift+-=new_split:down"
        "ctrl+shift+]=goto_split:right"
        "ctrl+shift+[=goto_split:left"
        "super+w=toggle_tab_overview"
      ];
    };
  };

}
