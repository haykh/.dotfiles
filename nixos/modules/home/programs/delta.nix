{
  config,
  lib,
  ...
}:

let
  this = config.my.programs.delta;
in
{

  options.my.programs.delta.enable = lib.mkEnableOption "delta";

  config = lib.mkIf this.enable {

    programs.delta = {
      enable = true;

      options = {
        features = "arctic-fox";
        side-by-side = true;
        navigate = true;
      };
      enableGitIntegration = true;
    };

  };

}
