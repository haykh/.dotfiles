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
      url = "https://flakehub.com/f/Rishabh5321/thorium_flake/0.1.59";
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
            modules = [
              inputs.nixos-hardware.nixosModules.framework-16-7040-amd
              (import ./hosts/fw16.nix {
                stateVersion = settings.stateVersion;
                hostPlatform = settings.system;
                hostname = "nixwrk";
              })
              (import ./hosts/global.nix {
                user = cfg.user;
                home = cfg.home;
              })
              (import ./modules/kvm.nix { user = cfg.user; })
              (import ./modules/locale.nix)
              # (import ./modules/gnome.nix)
              (import ./modules/plasma.nix)
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
              config.cudaSupport = true;
            };
            system = settings.system;
            modules = [
              nixos-wsl.nixosModules.default
              {
                system.stateVersion = settings.stateVersion;
                wsl.enable = true;
                wsl.defaultUser = cfg.user;
              }
              (import ./hosts/wsl.nix {
                stateVersion = settings.stateVersion;
                hostPlatform = settings.system;
                hostname = "nixwsl";
              })
              (import ./hosts/global.nix {
                user = cfg.user;
                home = cfg.home;
              })
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
