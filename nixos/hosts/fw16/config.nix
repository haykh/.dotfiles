{ inputs, pkgs, ... }:

let
  thoriumPkgs = inputs.thorium.packages.${pkgs.system};
  zenPkgs = inputs.zen-browser.packages.${pkgs.system};
  nogoPkgs = inputs.nogo.packages.${pkgs.system};
in
{

  extraFiles = config: cfg: {
    ".config/touchegg/touchegg.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/touchegg/touchegg.conf";

    ".config/GIMP/3.0/themes/Photoshop" = {
      source = config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/GIMP/3.0/themes/Photoshop";
      force = true;
    };
    ".config/GIMP/3.0/controllerrc" = {
      source = config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/GIMP/3.0/controllerrc";
      force = true;
    };
    ".config/GIMP/3.0/shortcutsrc" = {
      source = config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/GIMP/3.0/shortcutsrc";
      force = true;
    };

    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/nvim";

    ".local/bin/wl-color-picker" = {
      text = ''
        #!/usr/bin/env bash
        function pick() {
          qdbus --literal org.kde.KWin.ScreenShot2 /ColorPicker org.kde.kwin.ColorPicker.pick | sed 's/^[^0-9]*//;s/[^0-9]*$//;'
        }
        function to_rgb() {
          local argb=$(printf "%x" "$1")
          printf '#%02x%02x%02x' "$((0x$argb >> 16 & 0xff))" "$((0x$argb >> 8 & 0xff))" "$((0x$argb & 0xff))"
        }
        color="$(pick)"
        if [ -z "$color" ]; then
          echo "No color picked"
          exit 1
        fi
        rgb=$(to_rgb "$color")
        wl-copy "$rgb" && kdialog --passivepopup "$rgb" 3 --title "picked color" --icon 'color'
      '';
      executable = true;
    };

    ".local/bin/wl-color-chooser" = {
      text = ''
        #!/usr/bin/env bash
        kdialog --getcolor | wl-copy
      '';
      executable = true;
    };

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
    kdePackages.kdialog
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
    libgcc
    go
    gopls

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
    ffmpeg
    imagemagick
    chafa
    libqalculate
    slides
    has
    nogoPkgs.default

    # apps
    ## graphics & media
    godot
    blender-hip
    freecad
    gimp3-with-plugins
    inkscape-with-extensions
    libreoffice-qt6-fresh
    oculante
    tidal-hifi

    ## utils
    exhibit
    rofimoji
    protonvpn-gui
    proton-pass
    obsidian
    gnome-text-editor

    ## science
    paraview

    ## frameworks
    rocmPackages.clr

    ## web
    thoriumPkgs.thorium-avx2
    zenPkgs.zen-browser
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
        ebgaramond
        ebgaramond-maths
        svn-prov
        xkeyval
        fontaxes
        ;
    })

    cascadia-code
    nerd-fonts.monaspace
    nerd-fonts.blex-mono
    nerd-fonts.jetbrains-mono
  ];

  derivations = [ ];

  modules = {
    zsh = true;
    starship = true;
    eza = true;
    fzf = true;
    git = true;
    neovim = true;
    ssh = true;
    fastfetch = true;

    plasma = true;

    ghostty = true;
    mpv = true;
    rofi = true;
    vscode = true;
    zathura = true;
  };

  services = {
    ssh-agent.enable = true;
    kdeconnect.enable = true;
  };

  desktopEntries = [
    "kdecolorpick"
    "kdecolorchoose"
    "llyfr"
    "crifo"
    "chromium"
    "thorium"
    "slack"
    "vscode"
  ];

  mimeApps = {
    defaultApplications = {
      "inode/directory" = "org.kde.dolphin.desktop";
      "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";

      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
      "x-scheme-handler/slack" = "slack.desktop";
      "x-scheme-handler/terminal" = "ghostty.desktop";

      "image/gif" = "oculante.desktop";
      "image/png" = "oculante.desktop";
      "image/jpeg" = "oculante.desktop";

      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
    };
  };

  extraConfigs = [
    "gtk"
  ];

  userServices = [ ];

}
