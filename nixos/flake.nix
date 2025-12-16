{

  description = "master flake";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-25.11";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    thorium = {
      url = "https://flakehub.com/f/Rishabh5321/thorium_flake/0.1.78";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nogo = {
      url = "github:haykh/nogo";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      nixos-wsl,
      home-manager,
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
            };
            system = settings.system;
            specialArgs = {
              inherit inputs cfg;
              user = cfg.user;
              home = cfg.home;
            };
            modules = [
              inputs.nixos-hardware.nixosModules.framework-16-7040-amd
              ./hosts/fw16/disks.nix
              ./hosts/fw16/boot.nix
              ./hosts/fw16.nix
              {
                system.stateVersion = settings.stateVersion;
                nixpkgs.hostPlatform = settings.system;
                programs.nix-ld.enable = true;
                networking.hostName = "nixwrk";
              }
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
                  inputs.plasma-manager.homeModules.plasma-manager
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
              user = cfg.user;
              home = cfg.home;
            };
            modules = [
              nixos-wsl.nixosModules.default
              {
                system.stateVersion = settings.stateVersion;
                nixpkgs.hostPlatform = settings.system;
                wsl.enable = true;
                wsl.defaultUser = cfg.user;
                networking.hostName = "nixwsl";
              }
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
                    configuration = import ./hosts/wsl/config.nix { inherit inputs pkgs; };
                  }
                );
              }
            ];
          };
      };
    };

}
