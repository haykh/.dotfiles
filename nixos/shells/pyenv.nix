{
  pkgs ? import <nixpkgs> { },
}:

let
  name = "py";
  env = (
    import ./envs.nix {
      inherit pkgs;
      env = [
        "python"
        "cpp"
      ];
    }
  );
in
pkgs.mkShell (
  env.envVars
  // {
    name = "${name}-env";
    nativeBuildInputs = env.nativeBuildInputs;

    shellHook = ''
      ${env.preShellHook}
      export VENV_DIR="/tmp/.venv"
      if [ ! -d "$VENV_DIR" ]; then
        python3 -m venv "$VENV_DIR"
        source "$VENV_DIR/bin/activate"
        pip install --upgrade pip --quiet
        pip install numpy matplotlib euporie ipykernel --quiet
      else
        source "$VENV_DIR/bin/activate"
      fi
      ${env.postShellHook {
        name = name;
        cmd = "python3";
      }}
    '';
  }
)
