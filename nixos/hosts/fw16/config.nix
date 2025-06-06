{ inputs, pkgs, ... }:

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

    # ".local/share/applications/kdeactionsslack.desktop".text = ''
    #   [Desktop Entry]
    #   Name=slack
    #   Exec=${cfg.dotfiles}/scripts/kde-actions.sh slack
    #   Type=Application
    # '';
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
    libinput
    libinput-gestures
    ydotool
    xdotool

    # kde
    kdePackages.sddm-kcm
    wayland-utils

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
    gopls
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
    slides
    has

    # apps
    ## graphics & media
    unityhub
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
    gnome-text-editor

    ## science
    jabref
    paraview

    ## frameworks
    rocmPackages.clr

    ## web
    inputs.thorium.packages.${pkgs.system}.thorium-avx2
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
    "ktoggle"
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

  desktopEntries = [
    "llyfr"
    "crifo"
    "onlyoffice"
    "chromium"
    "thorium"
    "slack"
    "vscode"
  ];

  mimeApps = {
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";

      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
      "x-scheme-handler/slack" = "slack.desktop";

      "image/gif" = "oculante.desktop";
      "image/png" = "oculante.desktop";
      "image/jpeg" = "oculante.desktop";

      "x-scheme-handler/mailto" = "thunderbird.desktop";

      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
    };
  };

  extraConfigs = [
    "gtk"
    # "gnome"
  ];

}
