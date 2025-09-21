{ pkgs, ... }:

{

  defaultEditor = true;
  extraLuaPackages = ps: [ ps.magick ];
  extraPackages = [ pkgs.imagemagick ];
  plugins = [ pkgs.vimPlugins.nvim-treesitter.withAllGrammars ];

}
