{
  pkgs,
  cfg,
  ...
}:

{
  enable ? { },
}:

let
  cwd = builtins.path { path = ./.; };
in
builtins.mapAttrs (
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
) (pkgs.lib.attrsets.filterAttrs (_: v: v) enable)
