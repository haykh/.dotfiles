{ pkgs, ... }:

{

  imports = [
    ./hyprland.nix
    ./noctalia.nix
    ./hypridle.nix
  ];

  home.packages = with pkgs; [
    # screenshots (grim capture + slurp region + satty annotate)
    grim
    slurp
    satty

    # clipboard
    wl-clipboard
    cliphist

    # color picker
    hyprpicker

    # tray applets
    networkmanagerapplet
    blueman

    # audio mixer
    pavucontrol

    # media key control
    playerctl

    # Wrapper for the XFCE terminal helper: exo's X-XFCE-Commands is treated as
    # a bare binary name (it drops any flags), so we can't pass
    # --gtk-single-instance there directly. A non-single-instance Ghostty opens
    # in the CWD exo sets (the selected folder); the default single-instance
    # one hands off to the running instance and ignores the folder.
    (pkgs.writeShellScriptBin "ghostty-here" ''
      exec ghostty --gtk-single-instance=false "$@"
    '')
  ];

  # Ensure the screenshot save folder exists (satty --output-filename target).
  home.file."Pictures/Screenshots/.keep".text = "";

  # Thunar's "Open Terminal Here" uses XFCE's TerminalEmulator helper (not XDG
  # MIME). Register Ghostty as a custom helper and select it, otherwise Thunar
  # errors with "failed to launch preferred application for category
  # TerminalEmulator".
  # The helper id (filename + helpers.rc value) must match the command exo
  # runs — exo launches the helpers.rc value as the binary, so it has to be the
  # `ghostty-here` wrapper, not bare `ghostty`.
  xdg.dataFile."xfce4/helpers/ghostty-here.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=X-XFCE-Helper
    X-XFCE-Category=TerminalEmulator
    Name=Ghostty
    Icon=com.mitchellh.ghostty
    X-XFCE-Commands=ghostty-here
    X-XFCE-CommandsWithParameter=ghostty-here -e "%s"
  '';
  xdg.configFile."xfce4/helpers.rc".text = "TerminalEmulator=ghostty-here\n";

}
