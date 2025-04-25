{ inputs, cfg }:

{
  pkgs,
  config,
  ...
}:

let
  home = cfg.home;
  dotfiles = "${cfg.home}/.dotfiles";
  gtktheme = {
    accent = "#7295F6";
    main = {
      pkg = "fluent-gtk-theme";
      interface = "Fluent-Dark";
      env = "Fluent:dark";
    };
    icon = {
      pkg = "fluent-icon-theme";
      interface = "Fluent-dark";
    };
    cursor = {
      pkg = "capitaine-cursors-themed";
      interface = "Capitaine Cursors";
    };
    wallpaper = "${dotfiles}/wallpapers/blueish-sunrise.jpg";
  };
  bindings = {
    terminal = {
      binding = "<Super>t";
      action = "ghostty";
    };
    browser = {
      binding = "<Super>f";
      action = "zen";
    };
    nautilus = {
      binding = "<Super>e";
      action = "nautilus";
    };
    rofi-icons = {
      binding = "<Control><Super>i";
      action = "${dotfiles}/.config/rofi/apps/launch --nerdicons > /dev/null 2> &1";
    };
    calc = {
      binding = "<Control><Super>c";
      action = "${cfg.home}/.local/bin/crifo > /dev/null 2> &1";
    };
    refs = {
      binding = "<Control><Super>a";
      action = "${cfg.home}/.local/bin/llyfr ${cfg.home}/Documents/Literature/refs.bib > /dev/null 2> &1";
    };
    rofi-moji = {
      binding = "<Control><Super>j";
      action = "${dotfiles}/.config/rofi/apps/launch --emojis > /dev/null 2> &1";
    };
    rofi-drun = {
      binding = "<Control><Super>r";
      action = "${dotfiles}/.config/rofi/apps/launch --drun > /dev/null 2> &1";
    };
    largersize = {
      binding = "<Super>equal";
      action = "${dotfiles}/scripts/actions.sh --enlarge";
    };
    closewindow = {
      binding = "<Super>q";
      action = "${dotfiles}/scripts/actions.sh --close";
    };
    pickcolor = {
      binding = "<Control>Print";
      action = "${dotfiles}/scripts/actions.sh --pick-color";
    };
    open-slack = {
      binding = "<Super>s";
      action = "${dotfiles}/scripts/actions.sh --open slack";
    };
    open-email = {
      binding = "<Super>k";
      action = "${dotfiles}/scripts/actions.sh --open email";
    };
    screenshot-select = {
      binding = "Print";
      action = "${dotfiles}/scripts/actions.sh --screenshot select";
    };
    screenshot-full = {
      binding = "<Control>Print";
      action = "${dotfiles}/scripts/actions.sh --screenshot full";
    };
    screenshot-gui = {
      binding = "<Alt>Print";
      action = "${dotfiles}/scripts/actions.sh --screenshot gui";
    };
  };
  shell_aliases = {
    vi = "nvim";
    vim = "nvim";
    ff = "fastfetch";
    nixbuild = "sudo nixos-rebuild switch --flake ${dotfiles}/nixos";
    nixupd = "nix flake update --flake ${dotfiles}/nixos";
    homecfg = "$EDITOR ${dotfiles}/nixos/home.nix";
    flakecfg = "$EDITOR ${dotfiles}/nixos/flake.nix";
    nixcfg = "$EDITOR ${dotfiles}/nixos/";
    cat = "bat -pp --theme=TwoDark";
    ll = "ls --long --header --time-style=long-iso";
    lt = "ls --tree --level 2 --icons=always --color";
    ld = "ls --long --header --time-style=long-iso --total-size";
    icat = "chafa -f kitty";
    rclone-reload = "systemctl --user restart mount-drives.service";
  };
in
{
  home.username = "${cfg.user}";
  home.homeDirectory = "${cfg.home}";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
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
    nodejs_23
    wineWowPackages.stable
    rustup
    luajitPackages.luarocks
    # older lua compatible with certain nvim plugins
    lua51Packages.lua
    python312
    gcc
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
    mapscii
    chafa
    libqalculate

    # apps
    ## graphics & media
    blender-hip
    freecad
    gimp-with-plugins
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
    (pkgs.callPackage ./derivations/nogo.nix { inherit pkgs; })

    ## science
    jabref
    paraview

    ## frameworks
    rocmPackages.clr

    ## web
    (pkgs.callPackage ./derivations/zen.nix { inherit pkgs; })
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
      #(setq org-latex-compiler "lualatex")
      #(setq org-preview-latex-default-process 'dvisvgm)
    })

    (nerdfonts.override {
      fonts = [
        "Monaspace"
        "IBMPlexMono"
        "JetBrainsMono"
      ];
    })
  ];

  home.file = {
    ".config/touchegg/touchegg.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/touchegg/touchegg.conf";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.config/nvim";
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
  };

  imports = [
    (import ./configs/gtk.nix {
      inherit
        pkgs
        gtktheme
        bindings
        ;
    })
    (import ./configs/desktopapps.nix { themeEnv = gtktheme.main.env; })
    (import ./configs/ghostty.nix)
    (import ./configs/zsh.nix { inherit pkgs dotfiles shell_aliases; })
    (import ./configs/starship.nix)
    (import ./configs/ssh.nix { inherit home; })
    (import ./configs/drives.nix)
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      extraLuaPackages = ps: [ ps.magick ];
      extraPackages = [ pkgs.imagemagick ];
    };

    vscode = {
      enable = true;
      package = pkgs.vscode;
    };

    thunderbird = {
      settings = {
        "mail.shell.checkDefaultClient" = false;
        "mailnews.mark_message_read.auto" = false;
        "privacy.donottrackheader.enabled" = true;
        "datareporting.healthreport.uploadEnabled" = false;
      };
      profiles.${cfg.user}.isDefault = true;
      enable = true;
    };

    git = {
      enable = true;
      userName = cfg.git.username;
      userEmail = cfg.git.email;
      extraConfig = {
        pull.rebase = false;
        init.defaultBranch = "master";
      };
    };

    mpv = {
      enable = true;
      config = {
        keep-open = true;
        autofit = "75%x85%";
        screenshot-directory = "${home}/Pictures/Screenshots";
      };
      bindings = {
        "]" = "seek 5 exact";
        "[" = "seek -5 exact";
        "RIGHT" = "frame-step";
        "LEFT" = "frame-back-step";
        "v" = "vf toggle hflip";
      };
    };

    rofi = {
      enable = true;
      theme = "${dotfiles}/.config/rofi/config.rasi";
    };

    zathura = {
      enable = true;
      options = {
        selection-clipboard = "clipboard";
      };
    };

    home-manager.enable = true;
  };
}
