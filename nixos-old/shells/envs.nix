{ pkgs, env }:

let
  webPkgs = with pkgs; [
    nodejs
    vscode-langservers-extracted
    emmet-ls
    typescript-language-server
    taplo
    yaml-language-server
    markdown-oxide
    prettierd
    eslint
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
    libgcc
    clang-tools
    cmake
    neocmakelsp
    cmake-format
    cmake-lint
    raylib
  ];

  glPkgs = with pkgs; [
    zlib
    glslls
    clang-tools
  ];

  pythonPkgs = with pkgs; [
    python3
    ruff
    pyrefly
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

  asm = with pkgs; [
    nasm
    (import ../derivations/asm-lsp.nix { inherit pkgs; })
  ];

  rustPkgs = with pkgs; [
    rustc
    cargo
    rust-analyzer
    clippy
    rustfmt
    taplo
  ];

in
let
  nativeBuildInputs =
    [ ]
    ++ (if builtins.elem "web" env then webPkgs else [ ])
    ++ (if builtins.elem "go" env then goPkgs else [ ])
    ++ (if builtins.elem "cpp" env then cppPkgs else [ ])
    ++ (if builtins.elem "gl" env then glPkgs else [ ])
    ++ (if (builtins.elem "python" env) || (builtins.elem "py" env) then pythonPkgs else [ ])
    ++ (if builtins.elem "rocm" env then rocmPkgs else [ ])
    ++ (if builtins.elem "cuda" env then cudaPkgs else [ ])
    ++ (if builtins.elem "asm" env then asm else [ ])
    ++ (if builtins.elem "rust" env then rustPkgs else [ ]);
  _vars = {
    LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath (
      if (builtins.elem "cpp" env) || (builtins.elem "gl" env) || (builtins.elem "rust" env) then
        [
          pkgs.stdenv.cc.cc
          pkgs.zlib
        ]
      else
        [ ]
    );
  };
  envVars = builtins.listToAttrs (
    map (varName: {
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
      if [ -z "''${DIRENV_IN_ENVRC:-}" ] && [ -z "''${DIRENV_DIR:-}" ]; then
        exec $SHELL
      fi
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
