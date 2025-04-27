{
  stateVersion,
  hostPlatform,
  hostname,
}:

{
  config,
  lib,
  pkgs,
  ...
}:

{

  system.stateVersion = stateVersion;
  nixpkgs.hostPlatform = hostPlatform;
  networking.hostName = hostname;

}
