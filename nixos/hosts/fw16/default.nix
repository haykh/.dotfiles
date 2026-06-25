{
  inputs,
  cfg,
  ...
}:

{

  imports = [
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    ./disks.nix
    ./boot.nix
    ./hardware.nix
    ../../modules/system
    inputs.home-manager.nixosModules.home-manager
  ];

  system.stateVersion = "24.11";
  nixpkgs.hostPlatform = "x86_64-linux";
  programs.nix-ld.enable = true;
  networking.hostName = "nixwrk";

  # system modules enabled on this host
  my.locale.enable = true;
  my.virtualisation.kvm.enable = true;
  my.desktops.hyprland.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = { inherit inputs cfg; };
    # sharedModules = [
    #   inputs.plasma-manager.homeModules.plasma-manager
    # ];
    users.${cfg.user} = import ./home.nix;
  };

}
