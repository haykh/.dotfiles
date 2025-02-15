{
  pkgs ? import <nixpkgs> { },
  lang ? null,
}:

let
  name = "exercism";
  env = (
    import ./envs.nix {
      inherit pkgs;
      env = (if lang == null then [ ] else (pkgs.lib.strings.splitString "," lang));
    }
  );
in
pkgs.mkShell (
  env.envVars
  // {
    name = "${name}-env";
    nativeBuildInputs = env.nativeBuildInputs ++ [ pkgs.exercism ];

    shellHook = ''
      ${env.preShellHook}
      ${env.postShellHook {
        name = name;
        cmd = "exercism";
      }}
    '';
  }
)
