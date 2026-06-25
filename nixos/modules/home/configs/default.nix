{ lib, ... }:

{

  # Auto-import every config module (gtk, …). Each is gated by a
  # `my.configs.<name>.enable` option (default off).
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
