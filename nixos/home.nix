{ cfg }:

{
  pkgs,
  config,
  ...
}:

let
  home = cfg.home;
  dotfiles = "${cfg.home}/.dotfiles";
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

    # compilers & managers
    nix-init
    nodePackages_latest.nodejs
    wineWowPackages.stable
    rustup
    luajitPackages.luarocks
    lua
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

    # shell
    fd
    bc
    jq
    wget
    curl
    unzip
    fzf
    eza
    bat
    tldr
    ripgrep
    lazygit
    fastfetch
    ffmpeg
    mapscii

    # apps
    inkscape-with-extensions
    blender-hip
    freecad
    jabref
    onlyoffice-desktopeditors
    zoom-us
    neovim
    slack
    oculante
    tidal-hifi
    telegram-desktop
    obsidian
    rofimoji
    gimp-with-plugins
    nextcloud-client
    gpick

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
    (import ./configs/zsh.nix { inherit pkgs dotfiles; })
    ./configs/starship.nix
    (import ./configs/gtk.nix { inherit pkgs dotfiles; })
    ./configs/wezterm.nix
    (import ./configs/ssh.nix { inherit home; })
    ./configs/vscode.nix
    ./configs/drives.nix
  ];

  programs = {
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
