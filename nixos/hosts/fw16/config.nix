{ pkgs, ... }:

{

  extraFiles = config: cfg: {
    ".config/touchegg/touchegg.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/touchegg/touchegg.conf";

    ".config/GIMP/3.0/themes/Photoshop".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/GIMP/3.0/themes/Photoshop";
    ".config/GIMP/3.0/controllerrc".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/GIMP/3.0/controllerrc";
    ".config/GIMP/3.0/shortcutsrc".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/GIMP/3.0/shortcutsrc";

    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/nvim";

    ".local/share/applications/llyfr.desktop".text = ''
      [Desktop Entry]
      Exec=env GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb ~/.local/bin/llyfr ~/Documents/Literature/refs.bib
      Name=llyfr
      NoDisplay=true
      StartupNotify=false
      Type=Application
      X-KDE-GlobalAccel-CommandShortcut=true
    '';

    ".local/share/applications/crifo.desktop".text = ''
      [Desktop Entry]
      Exec=env GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb ~/.local/bin/crifo
      Name=crifo
      NoDisplay=true
      StartupNotify=false
      Type=Application
      X-KDE-GlobalAccel-CommandShortcut=true
    '';
  };

  sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
  };

  packages = with pkgs; [
    # system
    btop
    wmctrl
    rclone
    cntr
    gnupg

    # hardware controllers
    brightnessctl
    pamixer

    # compilers & managers
    nodePackages.nodejs
    wineWowPackages.stable
    rustup
    luajitPackages.luarocks
    lua
    python312
    gcc
    wails
    go
    webkitgtk_4_0
    libgcc

    # formatters & language servers
    ## nix
    nixfmt-rfc-style
    nil
    ## lua
    stylua
    lua-language-server
    ## shell
    shfmt
    bash-language-server

    # shell
    fd
    bc
    jq
    wget
    curl
    unzip
    fzf
    bat
    tldr
    ripgrep
    lazygit
    fastfetch
    ffmpeg
    imagemagick
    chafa
    libqalculate

    # apps
    ## graphics & media
    blender-hip
    freecad
    gimp3-with-plugins
    inkscape-with-extensions
    oculante
    tidal-hifi

    ## utils
    onlyoffice-desktopeditors
    exhibit
    flameshot
    gpick
    rofimoji
    protonvpn-gui
    proton-pass
    obsidian
    # (pkgs.callPackage "${derivationsDir}/nogo.nix" { inherit pkgs; })
    gnome-text-editor

    ## science
    jabref
    paraview

    ## frameworks
    rocmPackages.clr

    ## web
    # (pkgs.callPackage "${derivationsDir}/zen.nix" { inherit pkgs; })
    nextcloud-client
    slack
    zoom-us
    protonmail-desktop
    telegram-desktop
    mullvad-browser

    ## dev
    cutter
    devtoolbox

    heroic
    steam-run

    (pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-basic
        dvisvgm
        type1cm
        xcolor
        cm-super
        underscore
        dvipng
        wrapfig
        amsmath
        ulem
        hyperref
        capt-of
        ;
    })

    nerd-fonts.monaspace
    nerd-fonts.blex-mono
    nerd-fonts.jetbrains-mono
  ];

  derivations = [
    "nogo"
    "zen"
  ];

  modules = {
    zsh = true;
    starship = true;
    eza = true;
    fzf = true;
    git = true;
    neovim = true;
    ssh = true;

    plasma = true;

    ghostty = true;
    mpv = true;
    rofi = true;
    thunderbird = true;
    vscode = true;
    zathura = true;
  };

  services = {
    ssh-agent.enable = true;
  };

  desktopapps = [
    "onlyoffice"
    "chromium"
    "slack"
    "vscode"
    "mimeapps"
  ];

  extraConfigs = [
    "gtk"
    # "gnome"
  ];

}
