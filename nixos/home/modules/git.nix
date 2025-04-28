{ cfg, ... }:

{

  userName = cfg.git.username;
  userEmail = cfg.git.email;
  extraConfig = {
    pull.rebase = false;
    init.defaultBranch = "master";
    include.path = "${cfg.dotfiles}/.config/themes.gitconfig";
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
