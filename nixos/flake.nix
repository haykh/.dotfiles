{

  description = "master flake";

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://noctalia.cachix.org"
      "https://vicinae.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    ];
  };

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
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    pixie-sddm = {
      url = "github:xCaptaiN09/pixie-sddm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      devSystem = "x86_64-linux";
      devPkgs = import nixpkgs {
        system = devSystem;
        config.allowUnfree = true;
      };
      mkDev =
        lang:
        import ./shells/dev.nix {
          pkgs = devPkgs;
          inherit lang;
        };
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
                home-manager.extraSpecialArgs = { inherit inputs cfg; };
                # home-manager.sharedModules = [
                #   inputs.plasma-manager.homeModules.plasma-manager
                # ];
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

      devShells.${devSystem} = {
        default = mkDev null;

        # single-language shells (see shells/envs.nix for available envs)
        go = mkDev "go";
        cpp = mkDev "cpp";
        gl = mkDev "gl";
        python = mkDev "python";
        cuda = mkDev "cuda";
        rocm = mkDev "rocm";
        asm = mkDev "asm";
        rust = mkDev "rust";

        # common combinations
        py-cpp = mkDev "python,cpp";
        web = mkDev "web,gl,go";
        cuda-cpp = mkDev "cuda,cpp";
        rocm-cpp = mkDev "rocm,cpp";
      };
    };

}
