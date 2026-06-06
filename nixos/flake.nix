{

  description = "master flake";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-26.05";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-26.05";
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
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    gobrain = {
      url = "github:haykh/gobrain";
    };
    vicinae = {
      url = "github:vicinaehq/vicinae";
    };
    vicinae-extensions = {
      url = "github:vicinaehq/extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-code = {
      url = "github:sadjow/claude-code-nix";
    };
    pixie-sddm = {
      url = "github:xCaptaiN09/pixie-sddm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Noctalia (Quickshell-based bar/shell, replaces waybar). Intentionally NOT
    # following nixpkgs: it requires a newer Quickshell than nixos-26.05 ships,
    # so it uses its own (unstable) nixpkgs for the shell + quickshell.
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
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
            pkgs = import nixpkgs {
              system = settings.system;
              config.allowUnfree = true;
            };
            configuration = import ./hosts/fw16/config.nix { inherit inputs cfg pkgs; };
          in
          nixpkgs.lib.nixosSystem {
            inherit pkgs;
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
              (./modules + "/${configuration.desktop}.nix")
              {
                nixpkgs.overlays = [ inputs.claude-code.overlays.default ];
              }
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "bak";
                # specialArgs (unlike _module.args) are usable in `imports`,
                # which the desktop bundles need to import flake-provided
                # home modules (e.g. noctalia).
                home-manager.extraSpecialArgs = { inherit inputs cfg; };
                home-manager.sharedModules = [
                  inputs.plasma-manager.homeModules.plasma-manager
                ];
                home-manager.users.${cfg.user} = (
                  import ./home/home.nix {
                    inherit inputs cfg configuration;
                    stateVersion = settings.stateVersion;
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
                home-manager.extraSpecialArgs = { inherit inputs cfg; };
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
