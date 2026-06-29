{

  description = "master flake";

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://noctalia.cachix.org"
      "https://vicinae.cachix.org"
      "https://codex-cli.cachix.org"
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "codex-cli.cachix.org-1:1Br3H1hHoRYG22n//cGKJOk3cQXgYobUel6O8DgSing="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
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
    custom-packages = {
      url = "github:Rishabh5321/custom-packages-flake";
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
    codex-cli = {
      url = "github:sadjow/codex-cli-nix";
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
    toml2nix = {
      url = "github:haykh/toml2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia";
    };
  };

  outputs =
    inputs@{
      nixpkgs,
      ...
    }:
    let
      cfg = import ./cfg.nix { };

      mkSystem =
        { pkgs, modules }:
        nixpkgs.lib.nixosSystem {
          inherit pkgs;
          system = pkgs.stdenv.hostPlatform.system;
          specialArgs = {
            inherit inputs cfg;
            user = cfg.user;
            home = cfg.home;
          };
          inherit modules;
        };
    in
    {
      nixosConfigurations = {
        nixwrk = mkSystem {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays = [
              # openblas checkPhase (ctest) hangs only in the 32-bit build that
              # services.pipewire.alsa.support32Bit pulls in via pkgsi686Linux.
              # https://discourse.nixos.org/t/openblas-i686-linux-hangs-in-checkphase-on-zblat3/78487
              (final: prev: {
                pkgsi686Linux = prev.pkgsi686Linux.extend (
                  final686: prev686: {
                    openblas = prev686.openblas.overrideAttrs (_: {
                      doCheck = false;
                    });
                  }
                );
              })

              inputs.claude-code.overlays.default
            ];
          };
          modules = [ ./hosts/fw16 ];
        };

        nixwsl = mkSystem {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            # config.cudaSupport = true;
          };
          modules = [ ./hosts/wsl ];
        };
      };
    };

}
