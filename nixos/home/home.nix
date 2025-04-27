{
  inputs,
  cfg,
  stateVersion,
  configuration,
}:

{
  pkgs,
  config,
  ...
}:

let
  cwd = builtins.path { path = ./.; };
in
{
  home.username = "${cfg.user}";
  home.homeDirectory = "${cfg.home}";
  home.stateVersion = "${stateVersion}";

  home.sessionVariables = configuration.sessionVariables;

  home.packages = configuration.packages "${cwd}/derivations";

  home.file = configuration.extraFiles config cfg;

  imports =
    [
      (import ./desktopapps.nix { inherit cfg; } {
        entries = configuration.desktopapps;
      })
    ]
    ++ map (name: import "${cwd}/configs/${name}.nix" { inherit pkgs cfg; }) configuration.extraConfigs;

  programs = (
    import ./modules.nix { inherit pkgs cfg; } {
      enable = configuration.modules // {
        home-manager = true;
      };
    }
  );

  services = configuration.services;
}
