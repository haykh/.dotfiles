{
  stateVersion,
  hostPlatform,
  hostname,
  ...
}:

{

  system.stateVersion = stateVersion;
  nixpkgs.hostPlatform = hostPlatform;
  networking.hostName = hostname;

}
