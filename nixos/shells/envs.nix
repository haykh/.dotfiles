{ pkgs, env }:

let
  webPkgs = with pkgs; [
    nodePackages.nodejs
    vscode-langservers-extracted
    emmet-ls
    typescript-language-server
    taplo
    yaml-language-server
    markdown-oxide
    prettierd
    eslint_d
    mdformat
    svelte-language-server
  ];

  goPkgs = with pkgs; [
    go
    gopls
    gotools
    hugo
    wails
    prettier-plugin-go-template
  ];

  cppPkgs = with pkgs; [
    zlib
    llvmPackages_19.libcxxClang
    clang-tools
    cmake
    neocmakelsp
    cmake-format
    cmake-lint
  ];

  gccPkgs = with pkgs; [
    zlib
    gcc13
    clang-tools
    cmake
    neocmakelsp
    cmake-format
    cmake-lint
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
    taplo
    vscode-langservers-extracted
  ];

  rocmPkgs = with pkgs; [
    rocmPackages.hipcc
    rocmPackages.rocminfo
    rocmPackages.rocm-smi
  ];

  cudaPkgs = with pkgs; [
    cudaPackages.cudatoolkit
    cudaPackages.cuda_cudart
  ];

  adios2Pkgs = pkgs.callPackage ../home/derivations/adios2.nix {
    inherit pkgs;
    mpi = true;
    hdf5 = true;
  };

  asm = with pkgs; [
    nasm
    (import ../derivations/asm-lsp.nix { inherit pkgs; })
  ];

in
let
  nativeBuildInputs =
    [ ]
    ++ (if builtins.elem "web" env then webPkgs else [ ])
    ++ (if builtins.elem "go" env then goPkgs else [ ])
    ++ (if builtins.elem "cpp" env then cppPkgs else [ ])
    ++ (if builtins.elem "gcc" env then gccPkgs else [ ])
    ++ (if builtins.elem "gl" env then glPkgs else [ ])
    ++ (if builtins.elem "python" env then pythonPkgs else [ ])
    ++ (if builtins.elem "rocm" env then rocmPkgs else [ ])
    ++ (if builtins.elem "cuda" env then cudaPkgs else [ ])
    ++ (if builtins.elem "adios2" env then [ adios2Pkgs ] else [ ])
    ++ (if builtins.elem "asm" env then asm else [ ]);
  _vars = {
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (
      if ((builtins.elem "cpp" env) || (builtins.elem "gl" env) || (builtins.elem "gcc" env)) then
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
  preShellHook =
    ''
      RED='\033[0;31m'
      GREEN='\033[0;32m'
      BLUE='\033[0;34m'
      NC='\033[0m'
      export SHELL=$(which zsh)
    ''
    + (
      if builtins.elem "web" env then
        ''
          npm set prefix $HOME/.npm
          export PATH=$HOME/.npm/bin:$PATH
        ''
      else
        ""
    );
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
