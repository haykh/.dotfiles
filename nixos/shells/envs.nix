{ pkgs, env }:

let
  webPkgs = with pkgs; [
    nodejs_23
    vscode-langservers-extracted
    emmet-ls
    typescript-language-server
    taplo
    yaml-language-server
    markdown-oxide
    prettierd
    eslint_d
    mdformat
  ];

  cppPkgs = with pkgs; [
    zlib
    llvmPackages_19.libcxxClang
    clang-tools
    cmake
    neocmakelsp
    cmake-format
  ];

  glPkgs = with pkgs; [
    zlib
    glslls
    clang-tools
  ];

  pythonPkgs = with pkgs; [
    python312
    black
    pyright
  ];

in
let
  nativeBuildInputs =
    [ ]
    ++ (if builtins.elem "web" env then webPkgs else [ ])
    ++ (if builtins.elem "cpp" env then cppPkgs else [ ])
    ++ (if builtins.elem "gl" env then glPkgs else [ ])
    ++ (if builtins.elem "python" env then pythonPkgs else [ ]);
  _vars = {
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (
      if ((builtins.elem "cpp" env) || (builtins.elem "gl" env)) then
        [
          pkgs.stdenv.cc.cc
          pkgs.zlib
        ]
      else
        [ ]
    );
  };
  envVars = builtins.listToAttrs (
    builtins.map (varName: {
      name = varName;
      value = _vars.${varName};
    }) (builtins.attrNames _vars)
  );
  preShellHook = ''
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    BLUE='\033[0;34m'
    NC='\033[0m'
    export SHELL=$(which zsh)
  '';
  postShellHook =
    { name, cmd }:
    ''
      echo ""
         echo -e "${name} nix-shell activated: ''\${BLUE}$(which ${cmd})''\${NC}"
         exec $SHELL
    '';

in
{
  inherit
    nativeBuildInputs
    envVars
    preShellHook
    postShellHook
    ;
}