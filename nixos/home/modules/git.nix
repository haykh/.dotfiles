{ cfg, ... }:

{

  userName = cfg.git.username;
  userEmail = cfg.git.email;
  extraConfig = {
    pull.rebase = false;
    init.defaultBranch = "master";
  };
  diff-so-fancy = {
    enable = true;
  };

}
