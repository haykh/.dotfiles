{ pkgs, ... }:

{

  defaultEditor = true;
  withRuby = true;
  withPython3 = true;
  extraLuaPackages = ps: [ ps.magick ];
  extraPackages = [ pkgs.imagemagick ];
  initLua = ''
    require("config.lazy")
  '';

}
