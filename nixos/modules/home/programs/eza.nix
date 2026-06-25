{
  config,
  lib,
  ...
}:

let
  this = config.my.programs.eza;
in
{

  options.my.programs.eza.enable = lib.mkEnableOption "eza";

  config = lib.mkIf this.enable {

    programs.eza = {
      enable = true;

      enableZshIntegration = true;
      icons = "always";
      colors = "always";
      git = true;
      extraOptions = [
        "-a"
        "--sort=type"
      ];
    };

  };

}
