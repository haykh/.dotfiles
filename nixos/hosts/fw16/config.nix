{ pkgs, ... }:

{

  extraFiles = config: cfg: {
    ".config/touchegg/touchegg.conf".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/touchegg/touchegg.conf";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/nvim";
  };

  sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
  };

  packages =
    derivationsDir: with pkgs; [
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
      (pkgs.callPackage "${derivationsDir}/nogo.nix" { inherit pkgs; })

      ## science
      jabref
      paraview

      ## frameworks
      rocmPackages.clr

      ## web
      (pkgs.callPackage "${derivationsDir}/zen.nix" { inherit pkgs; })
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

      (nerdfonts.override {
        fonts = [
          "Monaspace"
          "IBMPlexMono"
          "JetBrainsMono"
        ];
      })
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
