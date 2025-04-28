{
  pkgs ? import <nixpkgs> {
    config.allowUnfree = true;
  },
  lang ? null,
}:

let
  name = "dev";
  langs = (if lang == null then [ ] else (pkgs.lib.strings.splitString "," lang));
  env = (
    import ./envs.nix {
      inherit pkgs;
      env = langs;
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
      echo -e "${name} nix-shell activated ${
        if lang == null then '''' else ''with ''\${BLUE}${lang}''\${NC}''
      }"
    '';
  }
)
