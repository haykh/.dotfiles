{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  this = config.my.programs.vicinae;
in
{

  # vicinae's options come from its own flake's home-manager module, so this
  # file pulls that in. Because of that external import it lives outside the
  # generic programs/ aggregator and is imported explicitly by hosts that use it.
  imports = [ inputs.vicinae.homeManagerModules.default ];

  options.my.programs.vicinae.enable = lib.mkEnableOption "vicinae launcher";

  config = lib.mkIf this.enable {

    programs.vicinae = {
      enable = true;

      systemd = {
        enable = true;
        autoStart = true;
        environment = {
          USE_LAYER_SHELL = 1;
        };
      };
      settings = {
        close_on_focus_loss = true;
        font = {
          normal = {
            size = 12;
          };
        };
        layer_shell = {
          enabled = true;
        };
        favorites = [ ];
      };
      extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
        nix
        power-profile
        ssh
        process-manager
        hypr
        nerdfont-search
      ];
      package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };

  };

}
