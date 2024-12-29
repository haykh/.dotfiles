{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "py312";
  nativeBuildInputs = with pkgs; [
    python312
    zlib
  ];

  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    pkgs.zlib
    pkgs.stdenv.cc.cc
  ];

  shellHook = ''
    BLUE='\033[0;34m'
    NC='\033[0m'
    export VENV_DIR="/tmp/.venv"
    export SHELL=$(which zsh)

    if [ ! -d "$VENV_DIR" ]; then
      python3 -m venv "$VENV_DIR"
      source "$VENV_DIR/bin/activate"
      pip install --upgrade pip --quiet
      pip install numpy matplotlib euporie ipykernel --quiet
    else
      source "$VENV_DIR/bin/activate"
    fi

    echo ""
    echo -e "python nix-shell activated: ''\${BLUE}$(which python)''\${NC}"
    exec $SHELL
  '';
}
