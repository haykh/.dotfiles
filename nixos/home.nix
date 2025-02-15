{ cfg }:

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
    firefox = {
      binding = "<Super>f";
      action = "firefox";
    };
    nautilus = {
      binding = "<Super>e";
      action = "nautilus";
    };
    rofi-icons = {
      binding = "<Control><Super>i";
      action = "${dotfiles}/.config/rofi/apps/launch --nerdicons > /dev/null 2> &1";
    };
    rofi-calc = {
      binding = "<Control><Super>c";
      action = "${dotfiles}/.config/rofi/apps/launch --calc > /dev/null 2> &1";
    };
    rofi-refs = {
      binding = "<Control><Super>a";
      action = "${dotfiles}/.config/rofi/apps/launch --refs > /dev/null 2> &1";
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
    # ls = "EXA_ICON_SPACING=1 eza -a --icons=always --sort=type $@";
    # ll = "EXA_ICON_SPACING=1 eza -a --long --icons=always --header --sort=type --git --time-style=long-iso";
    # lt = "EXA_ICON_SPACING=1 eza -a --icons=always --sort=type --tree --level 2 --icons=always --color";
    # ld = "EXA_ICON_SPACING=1 eza -a --long --icons=always --header --sort=type --git --time-style=long-iso --total-size";
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
    nix-init

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

    # apps
    blender-hip
    rocmPackages.clr

    cutter
    devtoolbox
    exhibit
    flameshot
    freecad
    gimp-with-plugins
    gpick
    heroic
    inkscape-with-extensions
    jabref
    nextcloud-client
    obsidian
    oculante
    onlyoffice-desktopeditors
    paraview
    protonmail-desktop
    rofimoji
    slack
    telegram-desktop
    tidal-hifi
    ungoogled-chromium
    zoom-us

    # custom
    (pkgs.callPackage ./derivations/nogo.nix { inherit pkgs; })

    (pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-basic
        dvisvgm
        dvipng # for preview and export as html
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
    EDITOR = "nvim";
  };

  imports = [
    (import ./configs/zsh.nix { inherit pkgs dotfiles shell_aliases; })
    (import ./configs/starship.nix)
    (import ./configs/gtk.nix {
      inherit
        pkgs
        gtktheme
        bindings
        ;
    })
    # (import ./configs/wezterm.nix)
    (import ./configs/ghostty.nix)
    (import ./configs/ssh.nix { inherit home; })
    (import ./configs/desktopapps.nix { themeEnv = gtktheme.main.env; })
    (import ./configs/drives.nix)
  ];

  programs = {
    neovim = {
      enable = true;
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
      plugins = with pkgs; [
        rofi-calc
      ];
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
