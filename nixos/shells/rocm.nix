{
  pkgs ? import <nixpkgs> { },
}:

let
  name = "rocm";
  env = (
    import ./envs.nix {
      inherit pkgs;
      env = [
        "rocm"
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
      ${env.postShellHook {
        name = name;
        cmd = "hipcc";
      }}
    '';
  }
)
