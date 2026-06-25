{
  config,
  lib,
  ...
}:

let
  this = config.my.programs.fzf;
in
{

  options.my.programs.fzf.enable = lib.mkEnableOption "fzf";

  config = lib.mkIf this.enable {

    programs.fzf = {
      enable = true;

      enableZshIntegration = true;
    };

  };

}
