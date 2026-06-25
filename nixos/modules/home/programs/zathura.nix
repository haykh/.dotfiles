{
  config,
  lib,
  ...
}:

let
  this = config.my.programs.zathura;
in
{

  options.my.programs.zathura.enable = lib.mkEnableOption "zathura";

  config = lib.mkIf this.enable {

    programs.zathura = {
      enable = true;

      options = {
        selection-clipboard = "clipboard";
      };
    };

  };

}
