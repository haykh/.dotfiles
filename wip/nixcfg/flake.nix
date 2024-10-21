nixosConfigurations.nixwrk = nixkpgs.lib.nixosSystem {
  specialArgs = { inherit inputs; };
  modules = [
    ./hosts/nixwrk/configuration.nix
    inputs.home-manager.nixosModules.default
  ];
  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
};
