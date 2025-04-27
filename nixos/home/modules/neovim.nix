{ pkgs, ... }:

{

  defaultEditor = true;
  extraLuaPackages = ps: [ ps.magick ];
  extraPackages = [ pkgs.imagemagick ];

}
