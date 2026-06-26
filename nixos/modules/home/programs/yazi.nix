{
  config,
  lib,
  pkgs,
  ...
}:

let
  this = config.my.programs.yazi;
in
{

  options.my.programs.yazi.enable = lib.mkEnableOption "yazi";

  config = lib.mkIf this.enable {

    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "yy";
      settings = {
        mgr = {
          show_hidden = true;
          sort_by = "natural";
          sort_sensitive = false;
          sort_dir_first = true;
          sort_translit = true;
        };
        preview = {
          max_width = 2000;
          max_height = 2000;
        };
        plugin.prepend_previewers = [
          {
            url = "*.tar*";
            run = "piper --format=url -- tar tf \"$1\"";
          }
          {
            url = "*.md";
            run = "piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark \"$1\"";
          }
        ];
      };
      plugins = {
        git = pkgs.yaziPlugins.git;
        full-border = pkgs.yaziPlugins.full-border;
        githead = pkgs.fetchFromGitHub {
          owner = "llanosrocas";
          repo = "githead.yazi";
          rev = "v2.0.2";
          sha256 = "sha256-c8jwfVrgQBLii4Yv3B020TdlYyt4VI70pNzqbuXyOgE=";
        };
        faster-piper = pkgs.fetchFromGitHub {
          owner = "alberti42";
          repo = "faster-piper.yazi";
          rev = "v1.0";
          sha256 = "sha256-Rr1JYSDi4wWQu5DTMu3i2NfrXNG46idXKYJtRTuD38c=";
        };
        yaziline = pkgs.fetchFromGitHub {
          owner = "llanosrocas";
          repo = "yaziline.yazi";
          rev = "v2.5.4";
          sha256 = "sha256-gF21K8Sn9VFh6nKcM5dhTiAH1sOE9D/Gmc8i3J8m+S4=";
        };
        command-palette = pkgs.fetchFromGitHub {
          owner = "Mr-Ples";
          repo = "command-palette.yazi";
          rev = "main";
          sha256 = "sha256-Mt1q05YgexMyHpy8qQ778jBny9f7XrftDZXjzONZVxg=";
        };
      };
      flavors = {
        kanagawa = pkgs.fetchFromGitHub {
          owner = "dangooddd";
          repo = "kanagawa.yazi";
          rev = "main";
          sha256 = "sha256-Yz0zRVzmgbrk0m7OkItxIK6W0WkPze/t09pWFgziNrw=";
        };
      };
      theme = {
        flavor = {
          dark = "kanagawa";
        };
      };
      initLua = ''
        require("full-border"):setup()
        require("yaziline"):setup()
        require("git"):setup({
          order = 1500,
        })
        require("githead"):setup({
          order = {
            "__spacer__",
            "branch",
            "remote",
            "__spacer__",
            "tag",
            "__spacer__",
            "commit",
            "__spacer__",
            "behind_ahead_remote",
            "stashes",
            "state",
            "staged",
            "unstaged",
            "untracked",
          },

          show_numbers = false,

          branch_symbol = " ",
          branch_prefix = "on",
        })
      '';
    };

  };

}
