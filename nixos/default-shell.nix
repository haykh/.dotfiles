# with import <nixpkgs> { };
#
# let
#   pythonPackages = python3Packages;
# in
# pkgs.mkShell {
#   name = "global-python";
#   venvDir = "/tmp/venv";
#   buildInputs = [
#     pythonPackages.python
#     pythonPackages.venvShellHook
#   ];
#
#   runScript = "zsh";
#
# }
{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.python310
    pkgs.zlib
  ];

  shellHook = ''
    export LD_LIBRARY_PATH="${pkgs.zlib}/lib"
  '';
}
