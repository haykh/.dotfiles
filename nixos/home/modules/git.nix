{ cfg, ... }:

{

  settings = {
    user = {
      name = cfg.git.username;
      email = cfg.git.email;
    };
    pull.rebase = false;
    init.defaultBranch = "master";
    include.path = "${cfg.dotfiles}/.config/themes.gitconfig";
    alias = {
      lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
    };
  };
  lfs.enable = true;

}
