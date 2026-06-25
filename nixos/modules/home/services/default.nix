{ lib, ... }:

{

  # Auto-import every user-service module. Each is gated by a
  # `my.services.<name>.enable` option (default off).
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
