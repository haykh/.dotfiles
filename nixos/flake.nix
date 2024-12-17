{

  description = "master flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixos-hardware,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        system = "${system}";
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        nixwrk = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./fw16/fw16.nix
            ./configuration.nix
            ./ui/gnome.nix
            nixos-hardware.nixosModules.framework-16-7040-amd
          ];
        };
      };
      homeConfigurations = {
        hayk = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };
    };

}
