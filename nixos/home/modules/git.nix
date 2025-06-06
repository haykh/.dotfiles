{ cfg, ... }:

{

  userName = cfg.git.username;
  userEmail = cfg.git.email;
  extraConfig = {
    pull.rebase = false;
    init.defaultBranch = "master";
    include.path = "${cfg.dotfiles}/.config/themes.gitconfig";
    alias = {
      lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all";
    };
  };
  delta = {
    enable = true;
    options = {
      features = "arctic-fox";
      side-by-side = true;
      navigate = true;
    };
  };

}
