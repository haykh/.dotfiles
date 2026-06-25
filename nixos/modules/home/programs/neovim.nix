{
  config,
  lib,
  pkgs,
  ...
}:

let
  this = config.my.programs.neovim;
in
{

  options.my.programs.neovim.enable = lib.mkEnableOption "neovim";

  config = lib.mkIf this.enable {

    programs.neovim = {
      enable = true;

      defaultEditor = true;
      withRuby = true;
      withPython3 = true;
      extraLuaPackages = ps: [ ps.magick ];
      extraPackages = [ pkgs.imagemagick ];
      initLua = ''
        require("config.lazy")
      '';
    };

  };

}
