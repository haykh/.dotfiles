{
  pkgs ? import <nixpkgs> { },
}:

let
  name = "web";
  env = (
    import ./envs.nix {
      inherit pkgs;
      env = [
        "web"
        "gl"
        "go"
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
        cmd = "node";
      }}
    '';
  }
)
