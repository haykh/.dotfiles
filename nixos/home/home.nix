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
  all_desktop_entries = import ./desktop_entries.nix { inherit pkgs cfg; };
  desktop_entries = builtins.map (name: all_desktop_entries.${name}) (
    builtins.filter (name: builtins.hasAttr name all_desktop_entries) configuration.desktopEntries
  );
in
{

  home.username = "${cfg.user}";
  home.homeDirectory = "${cfg.home}";
  home.stateVersion = "${stateVersion}";

  home.sessionVariables = configuration.sessionVariables;

  home.packages =
    configuration.packages
    ++ builtins.map (
      p: pkgs.callPackage "${cwd}/derivations/${p}.nix" { inherit pkgs; }
    ) configuration.derivations;

  home.file =
    (configuration.extraFiles config cfg)
    // builtins.foldl' (a: b: a // b) { } desktop_entries;

  imports = map (
    name: import "${cwd}/configs/${name}.nix" { inherit pkgs cfg; }
  ) configuration.extraConfigs;

  xdg.mimeApps = {
    enable = true;
  } // configuration.mimeApps;

  programs =
    builtins.mapAttrs
      (
        prog: enable:
        (
          if (builtins.pathExists ("${cwd}/modules/${prog}.nix")) then
            (import ("${cwd}/modules/${prog}.nix") { inherit pkgs cfg; })
          else
            { }
        )
        // {
          inherit enable;
        }
      )
      (
        configuration.modules
        // {
          home-manager = true;
        }
      );

  services = configuration.services;

}
