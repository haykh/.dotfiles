{ pkgs, ... }:

{

  extraFiles = config: cfg: {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/nvim";
  };

  sessionVariables = {
    EDITOR = "nvim";
    CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      "/usr/lib/wsl"
      "${pkgs.cudaPackages.cudatoolkit}"
      "${pkgs.linuxPackages.nvidia_x11}"
      "${pkgs.stdenv.cc.cc}"
      "${pkgs.zlib}"
    ];
    EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
    EXTRA_CCFLAGS = "-I/usr/include";
  };

  packages = with pkgs; [
    # system
    rclone
    gnupg
    zlib

    # compilers & managers
    cmake
    gnumake
    nodejs_23
    rustup
    luajitPackages.luarocks
    # older lua compatible with certain nvim plugins
    lua51Packages.lua
    python312
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

    # cuda
    linuxPackages.nvidia_x11
    cudaPackages.cudatoolkit
    cudaPackages.cuda_cudart

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

    wezterm

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

  derivations = [ "nogo" ];

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

  desktopEntries = [ ];

  mimeApps = { };

  extraConfigs = [ ];

}
