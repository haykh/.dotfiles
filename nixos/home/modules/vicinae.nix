{ pkgs, inputs, ... }:

{

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

}
