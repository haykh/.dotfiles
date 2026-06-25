{ pkgs, cfg, ... }:

{
  # nix-direnv caches the evaluated devShell and pins it as a GC root, so
  # entering a project is instant and works offline after the first build.
  nix-direnv.enable = true;

  # zsh integration is enabled automatically when programs.zsh is on, but we
  # set it explicitly to be safe.
  enableZshIntegration = true;

  # keep direnv quiet on cd (drop the "loading"/"export N vars" chatter)
  silent = true;
}
