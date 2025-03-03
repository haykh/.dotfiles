{

  description = "master flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # plasma-manager = {
    #   url = "github:nix-community/plasma-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.home-manager.follows = "home-manager";
    # };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixos-hardware,
      # plasma-manager,
      ...
    }:
    let
      cfg = rec {
        user = "hayk";
        home = "/home/${user}";
        git = {
          username = "haykh";
          email = "haykh.astro@gmail.com";
        };
      };
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        nixwrk =
          let
            pkgs = import nixpkgs {
              inherit system;
              config = {
                allowUnfree = true;
              };
            };
          in
          nixpkgs.lib.nixosSystem {
            inherit system pkgs;
            modules = [
              nixos-hardware.nixosModules.framework-16-7040-amd
              (import ./fw16/fw16.nix)
              (import ./global.nix { inherit cfg; })
              (import ./modules/kvm.nix { user = cfg.user; })
              (import ./modules/locale.nix)
              # (import ./modules/plasma.nix)
              (import ./modules/gnome.nix)
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "bak";
                # home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
                home-manager.users.${cfg.user} = (import ./home.nix { inherit cfg; });
              }
            ];
          };
      };
    };
}
