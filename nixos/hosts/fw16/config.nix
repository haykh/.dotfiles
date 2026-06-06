{ inputs, pkgs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;

  thoriumPkgs = inputs.thorium.packages.${system};
  zenPkgs = inputs.zen-browser.packages.${system};
  gobrainPkgs = inputs.gobrain.packages.${system};

  opensslInject = pkgs.writeText "inject-openssl.cmake" ''
    find_package(OpenSSL REQUIRED)
  '';

  vicinaePatched = inputs.vicinae.packages.${system}.default.overrideAttrs (old: {
    buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.openssl ];

    cmakeFlags = (old.cmakeFlags or [ ]) ++ [
      "-DCMAKE_PROJECT_INCLUDE_BEFORE=${opensslInject}"
    ];
  });
in
{

  # Desktop environment for this host. Flip between "hyprland" and "plasma"
  # to switch — picks both the system module (modules/<desktop>.nix) and the
  # home-manager bundle (home/desktops/<desktop>/).
  desktop = "hyprland";

  extraFiles = config: cfg: {

    ".config/nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/nvim/lua";
    ".config/nvim/queries".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/nvim/queries";
    ".config/nvim/lazy-lock.json".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/nvim/lazy-lock.json";
    ".config/nvim/lazyvim.json".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/nvim/lazyvim.json";

    ".local/bin/wl-color-picker" = {
      text = ''
        #!/usr/bin/env bash
        function pick() {
          busctl --user call org.kde.KWin.ScreenShot2 /ColorPicker org.kde.kwin.ColorPicker pick | awk '{print $2}'
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
    devenv
    zip

    # kde
    kdePackages.sddm-kcm
    kdePackages.kdialog
    wayland-utils

    # hardware controllers
    brightnessctl
    pamixer

    # compilers & managers
    tree-sitter
    nodejs
    wineWow64Packages.stable
    rustup
    luajitPackages.luarocks
    lua
    python314
    gcc
    libgcc
    go
    racket

    # formatters & language servers
    ## nix
    nixfmt
    nil
    ## lua
    stylua
    lua-language-server
    ## shell
    shfmt
    bash-language-server
    ## toml
    # tombiPkgs.default
    ## go
    gopls

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
    gource
    highlight
    gobrainPkgs.default
    claude-code

    # apps
    ## graphics & media
    godot
    pkgsRocm.blender
    freecad
    gimp3-with-plugins
    inkscape-with-extensions
    libreoffice-qt6-fresh
    oculante
    tidal-hifi
    turbovnc

    ## utils
    exhibit
    proton-vpn
    proton-pass
    portaudio
    gnome-text-editor

    turbovnc

    ## science
    paraview

    ## frameworks
    rocmPackages.clr

    ## web
    thoriumPkgs.thorium-avx2
    zenPkgs.default
    slack
    protonmail-desktop
    telegram-desktop

    ## dev
    cutter
    devtoolbox

    heroic
    steam-run

    ## latex
    tex-fmt
    (pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-medium
        minted
        xstring
        framed
        upquote
        dvisvgm
        pgf
        tikz-cd
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
    delta = true;
    neovim = true;
    ssh = true;
    fastfetch = true;

    ghostty = true;
    mpv = true;
    # rofi = true;
    vscode = true;
    zathura = true;
  };

  services = {
    ssh-agent.enable = true;
    vicinae = {
      enable = true;
      systemd = {
        enable = true;
        autoStart = true;
        environment = {
          USE_LAYER_SHELL = 1;
        };
      };
      settings = {
        close_on_focus_loss = true;
        font = {
          normal = {
            size = 12;
          };
        };
        layer_shell = {
          enabled = true;
        };
        favorites = [ ];
      };
      extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
        nix
        power-profile
        ssh
        process-manager
      ];
      package = vicinaePatched;
    };
  };

  desktopEntries = [
    "kdecolorpick"
    "kdecolorchoose"
    "vicinae"
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
      "application/pdf" = "org.pwmt.zathura.desktop";

      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
      "x-scheme-handler/slack" = "slack.desktop";
      "x-scheme-handler/terminal" = "ghostty.desktop";

      "image/gif" = "oculante.desktop";
      "image/png" = "oculante.desktop";
      "image/jpeg" = "oculante.desktop";

      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
    };
  };

  extraConfigs = [
    "gtk"
  ];

  extraImports = [ inputs.vicinae.homeManagerModules.default ];

  userServices = [
    "drives"
    "literature-sync"
  ];

}
