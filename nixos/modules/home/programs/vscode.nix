{
  config,
  lib,
  pkgs,
  ...
}:

let
  this = config.my.programs.vscode;
in
{

  options.my.programs.vscode.enable = lib.mkEnableOption "vscode";

  config = lib.mkIf this.enable {

    programs.vscode = {
      enable = true;

      package = pkgs.vscode;
    };

  };

}
