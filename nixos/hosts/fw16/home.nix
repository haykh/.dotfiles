{
  config,
  lib,
  pkgs,
  cfg,
  inputs,
  ...
}:

let
  system = pkgs.stdenv.hostPlatform.system;

  thoriumPkgs = pkgs.symlinkJoin {
    name = "thorium-wayland";
    paths = [ inputs.custom-packages.packages.${system}.thorium-avx2 ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/thorium \
        --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
    '';
  };
  codexPkgs = inputs.codex-cli.packages.${system};
  zenPkgs = inputs.zen-browser.packages.${system};
  gobrainPkgs = inputs.gobrain.packages.${system};
  toml2nixPkgs = inputs.toml2nix.packages.${system};
in
{

  imports = [
    ../../modules/home # generic programs / configs / services
    ../../modules/home/desktops/hyprland # hyprland desktop (pulls noctalia)
    ../../modules/home/vicinae.nix # vicinae (pulls its own flake module)
  ];

  # home modules enabled on this host
  my.programs.zsh.enable = true;
  my.programs.starship.enable = true;
  my.programs.eza.enable = true;
  my.programs.fzf.enable = true;
  my.programs.git.enable = true;
  my.programs.delta.enable = true;
  my.programs.neovim.enable = true;
  my.programs.ssh.enable = true;
  my.programs.fastfetch.enable = true;
  my.programs.ghostty.enable = true;
  my.programs.mpv.enable = true;
  my.programs.vscode.enable = true;
  my.programs.zathura.enable = true;
  my.programs.vicinae.enable = true;
  my.programs.yazi.enable = true;
  my.configs.gtk.enable = true;

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
    # libudev.pc lives in udev's dev output; expose it so pkg-config can find
    # libudev for Rust crates like serialport -> libudev-sys.
    PKG_CONFIG_PATH = "${pkgs.udev.dev}/lib/pkgconfig";
  };

  home.packages = with pkgs; [
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
    pkg-config
    udev
    evtest

    # kde
    # kdePackages.sddm-kcm
    # kdePackages.kdialog
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
    nixd
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
    glow
    gobrainPkgs.default
    claude-code
    codexPkgs.default
    toml2nixPkgs.default

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
    proton-vpn-cli
    proton-pass
    filen-desktop
    portaudio
    gnome-text-editor
    mathematica
    sniffnet

    turbovnc

    ## science
    paraview

    ## frameworks
    rocmPackages.clr

    ## web
    thoriumPkgs
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

  home.file = {

    ".config/nvim/lua".source = config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/nvim/lua";
    ".config/nvim/queries".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/nvim/queries";
    ".config/nvim/lazy-lock.json".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/nvim/lazy-lock.json";
    ".config/nvim/lazyvim.json".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.dotfiles}/.config/nvim/lazyvim.json";

    ".local/share/oculante/config.json".text = builtins.toJSON {
      fit_image_on_window_resize = true;
    };

    # ".local/bin/wl-color-picker" = {
    #   text = ''
    #     #!/usr/bin/env bash
    #     function pick() {
    #       busctl --user call org.kde.KWin.ScreenShot2 /ColorPicker org.kde.kwin.ColorPicker pick | awk '{print $2}'
    #     }
    #     function to_rgb() {
    #       local argb=$(printf "%x" "$1")
    #       printf '#%02x%02x%02x' "$((0x$argb >> 16 & 0xff))" "$((0x$argb >> 8 & 0xff))" "$((0x$argb & 0xff))"
    #     }
    #     color="$(pick)"
    #     if [ -z "$color" ]; then
    #       echo "No color picked"
    #       exit 1
    #     fi
    #     rgb=$(to_rgb "$color")
    #     wl-copy "$rgb" && kdialog --passivepopup "$rgb" 3 --title "picked color" --icon 'color'
    #   '';
    #   executable = true;
    # };
    #
    # ".local/bin/wl-color-chooser" = {
    #   text = ''
    #     #!/usr/bin/env bash
    #     kdialog --getcolor | wl-copy
    #   '';
    #   executable = true;
    # };

  };

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "thunar.desktop";
    "application/pdf" = "org.pwmt.zathura.desktop";

    "image/gif" = "oculante.desktop";
    "image/png" = "oculante.desktop";
    "image/jpeg" = "oculante.desktop";
    "image/bmp" = "oculante.desktop";
    "image/tiff" = "oculante.desktop";
    "image/webp" = "oculante.desktop";
    "image/jp2" = "oculante.desktop";
    "image/jpeg2000" = "oculante.desktop";
    "image/jpx" = "oculante.desktop";
    "image/svg+xml" = "oculante.desktop";

    "text/plain" = "org.gnome.TextEditor.desktop";
    "text/markdown" = "org.gnome.TextEditor.desktop";
    "text/html" = "zen-beta.desktop";

    "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
    "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
    "x-scheme-handler/slack" = "slack.desktop";
    "x-scheme-handler/terminal" = "ghostty.desktop";
    "x-scheme-handler/http" = "zen.desktop";
    "x-scheme-handler/https" = "zen.desktop";
    "x-scheme-handler/about" = "zen.desktop";
    "x-scheme-handler/unknown" = "zen.desktop";
  };

  # Some managed files get rewritten as plain files by the apps that own them
  # (GTK -> ~/.gtkrc-2.0, the mime handler -> mimeapps.list, Slack -> its
  # .desktop). On the next switch home-manager backs each up to "<file>.bak",
  # but aborts if a .bak from the previous switch already exists. Clearing the
  # stale backups before the link check makes activation overwrite them every
  # time — this replaces the manual `rm -f` that used to live in the nixbuild
  # alias. Add new paths here if other files start colliding.
  home.activation.clearStaleBackups = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    rm -f \
      "$HOME/.gtkrc-2.0.bak" \
      "$HOME/.config/mimeapps.list.bak" \
      "$HOME/.local/share/applications/slack.desktop.bak"
  '';

  services.ssh-agent.enable = true;

}
