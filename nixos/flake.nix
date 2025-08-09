{

  description = "master flake";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-25.05";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    thorium = {
      url = "https://flakehub.com/f/Rishabh5321/thorium_flake/0.1.69";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixos-wsl,
      home-manager,
      plasma-manager,
      thorium,
      ...
    }:
    let
      cfg = import ./cfg.nix { };
    in
    {
      nixosConfigurations = {
        nixwrk =
          let
            settings = {
              stateVersion = "24.11";
              system = "x86_64-linux";
            };
          in
          nixpkgs.lib.nixosSystem rec {
            pkgs = import nixpkgs {
              system = settings.system;
              config.allowUnfree = true;
              config.permittedInsecurePackages = [
                "electron-33.4.11"
              ];
            };
            system = settings.system;
            specialArgs = {
              inherit inputs cfg;
              stateVersion = settings.stateVersion;
              hostPlatform = settings.system;
              hostname = "nixwrk";
              user = cfg.user;
              home = cfg.home;
            };
            modules = [
              inputs.nixos-hardware.nixosModules.framework-16-7040-amd
              ./hosts/fw16/disks.nix
              ./hosts/fw16/boot.nix
              ./hosts/fw16.nix
              ./hosts/global.nix
              ./modules/kvm.nix
              ./modules/locale.nix
              # (import ./modules/gnome.nix)
              ./modules/plasma.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "bak";
                home-manager.sharedModules = [
                  plasma-manager.homeManagerModules.plasma-manager
                ];
                home-manager.users.${cfg.user} = (
                  import ./home/home.nix {
                    inherit inputs cfg;
                    stateVersion = settings.stateVersion;
                    configuration = import ./hosts/fw16/config.nix { inherit inputs cfg pkgs; };
                  }
                );
              }
            ];
          };
        nixwsl =
          let
            settings = {
              stateVersion = "24.11";
              system = "x86_64-linux";
            };
          in
          nixpkgs.lib.nixosSystem rec {
            pkgs = import nixpkgs {
              system = settings.system;
              config.allowUnfree = true;
              # config.cudaSupport = true;
            };
            system = settings.system;
            specialArgs = {
              inherit inputs;
              stateVersion = settings.stateVersion;
              hostPlatform = settings.system;
              hostname = "nixwsl";
              user = cfg.user;
              home = cfg.home;
            };
            modules = [
              nixos-wsl.nixosModules.default
              {
                system.stateVersion = settings.stateVersion;
                wsl.enable = true;
                wsl.defaultUser = cfg.user;
              }
              ./hosts/wsl.nix
              ./hosts/global.nix
              { programs.nix-ld.enable = true; }
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "bak";
                home-manager.users.${cfg.user} = (
                  import ./home/home.nix {
                    inherit inputs cfg;
                    stateVersion = settings.stateVersion;
                    configuration = import ./hosts/wsl/config.nix { inherit pkgs; };
                  }
                );
              }
            ];
          };
      };
    };

}
