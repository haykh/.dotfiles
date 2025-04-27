{ pkgs, cfg, ... }:

{

  shellAliases = cfg.shell_aliases;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  sessionVariables = {
    EDITOR = "nvim";
  };

  initExtra = ''
    export PATH=$HOME/.local/bin:$PATH
    export EDITOR=nvim

    # zstyle ':completion:*:default' list-colors "ow=30;44"
    if [ -n "''${commands[fzf-share]}" ]; then
      source "$(fzf-share)/key-bindings.zsh"
      source "$(fzf-share)/completion.zsh"
    fi
    if [ -d "$HOME/.cargo" ]; then
      export PATH=$HOME/.cargo/bin:$PATH
    fi

    fpath+=${cfg.dotfiles}/.zsh_functions
    autoload -U ${cfg.dotfiles}/.zsh_functions/*
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

  plugins = [
    {
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.8.0";
        sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
      };
    }
  ];

}
