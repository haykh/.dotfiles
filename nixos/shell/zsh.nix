{ ... }:

let
  aliases = {
    vi = "nvim";
    vim = "nvim";
    ff = "fastfetch";
    homebuild = "home-manager switch --flake $HOME/.dotfiles/nixos";
    nixbuild = "sudo nixos-rebuild switch --flake $HOME/.dotfiles/nixos";
    homecfg = "nvim $HOME/.dotfiles/nixos/home.nix";
    flakecfg = "nvim $HOME/.dotfiles/nixos/flake.nix";
    nixcfg = "nvim $HOME/.dotfiles/nixos/configuration.nix";
    cat = "bat -pp --theme=TwoDark";
    ls = "EXA_ICON_SPACING=1 eza -a --icons --sort=type";
    ll = "EXA_ICON_SPACING=1 eza -a --long --icons --header --sort=type --git --time-style=long-iso";
    lt = "EXA_ICON_SPACING=1 eza -a --icons --sort=type --tree --level 2 --icons --color";
    ld = "EXA_ICON_SPACING=1 eza -a --long --icons --header --sort=type --git --time-style=long-iso --total-size";
  };
in
{

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = aliases;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initExtra = ''
      zstyle ':completion:*:default' list-colors "ow=30;44"
      if [ -n "''${commands[fzf-share]}" ]; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi
      if [ -d "$HOME/.cargo" ]; then
        export PATH=$HOME/.cargo/bin:$PATH
      fi

      fpath+=$HOME/.dotfiles/.zsh_functions
      autoload -U $fpath[-1]/*(.:t)
      fpath+=$HOME/.zfunc
      fpath+=$HOME/.zsh/functions
      autoload compinit -Uz && compinit
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "colorize"
        "colored-man-pages"
        "extract"
        "docker"
        "docker-compose"
      ];
    };
  };
}
