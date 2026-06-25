{ lib, ... }:

{

  # Auto-import every program module in this directory. Each declares a
  # `my.programs.<name>.enable` option (default off) and gates its config with
  # mkIf, so importing them all everywhere is free until a host opts in.
  imports =
    let
      dir = ./.;
      entries = builtins.readDir dir;
    in
    map (name: dir + "/${name}") (
      builtins.filter (name: name != "default.nix" && lib.hasSuffix ".nix" name) (
        builtins.attrNames entries
      )
    );

}
