{
  config,
  lib,
  cfg,
  ...
}:

let
  this = config.my.programs.rofi;
in
{

  options.my.programs.rofi.enable = lib.mkEnableOption "rofi";

  config = lib.mkIf this.enable {

    programs.rofi = {
      enable = true;

      theme = "${cfg.dotfiles}/.config/rofi/config.rasi";
    };

  };

}
