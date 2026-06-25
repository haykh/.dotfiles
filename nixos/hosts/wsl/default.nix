{
  inputs,
  cfg,
  ...
}:

{

  imports = [
    inputs.nixos-wsl.nixosModules.default
    ../../modules/system
    inputs.home-manager.nixosModules.home-manager
  ];

  system.stateVersion = "24.11";
  nixpkgs.hostPlatform = "x86_64-linux";
  programs.nix-ld.enable = true;

  wsl.enable = true;
  wsl.defaultUser = cfg.user;
  networking.hostName = "nixwsl";

  # No `my.*` desktop/locale/kvm toggles -> only the always-on global base from
  # modules/system applies (matches the original WSL system config).

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
    extraSpecialArgs = { inherit inputs cfg; };
    users.${cfg.user} = import ./home.nix;
  };

}
