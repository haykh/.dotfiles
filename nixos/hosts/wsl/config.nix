{ pkgs, ... }:

{

  extraFiles = config: cfg: {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/nvim";
  };

  sessionVariables = {
    EDITOR = "nvim";
  };

  packages =
    derivationsDir: with pkgs; [
      # system
      rclone
      gnupg

      # compilers & managers
      nodejs_23
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

      wezterm

      ## utils
      (pkgs.callPackage "${derivationsDir}/nogo.nix" { inherit pkgs; })

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
  };

  services = {
    ssh-agent.enable = true;
  };

  desktopapps = [
    "mimeapps"
  ];

  extraConfigs = [ ];

}
