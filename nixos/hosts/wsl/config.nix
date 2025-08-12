{ inputs, pkgs, ... }:

let
  nogoPkgs = inputs.nogo.packages.${pkgs.system};
in
{

  extraFiles = config: cfg: {
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/nvim";
  };

  sessionVariables = {
    EDITOR = "nvim";
    # CUDA_PATH = "${pkgs.cudaPackages.cudatoolkit}";
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
      "/usr/lib/wsl"
      # "${pkgs.cudaPackages.cudatoolkit}"
      # "${pkgs.linuxPackages.nvidia_x11}"
      "${pkgs.stdenv.cc.cc}"
      "${pkgs.zlib}"
    ];
    # EXTRA_LDFLAGS = "-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib";
    EXTRA_CCFLAGS = "-I/usr/include";
  };

  packages = with pkgs; [
    # system
    rclone
    gnupg
    zlib
    glib
    libGL
    fontconfig
    xorg.libX11
    libxkbcommon
    freetype
    dbus

    # compilers & managers
    cmake
    gnumake
    nodePackages.nodejs
    rustup
    luajitPackages.luarocks
    # older lua compatible with certain nvim plugins
    lua51Packages.lua
    python312
    libgcc
    gcc

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
    # linuxPackages.nvidia_x11
    # cudaPackages.cudatoolkit
    # cudaPackages.cuda_cudart

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
    gh
    nogoPkgs.default

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
  };

  services = {
    ssh-agent.enable = true;
  };

  desktopEntries = [ ];

  mimeApps = { };

  extraConfigs = [ ];

  userServices = [ ];

}
