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
    devenv = {
      url = "github:cachix/devenv";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprexpo = {
      url = "github:sandwichfarm/hyprexpo/hyprland-git";
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
              # nixpkgs#447287
              # (
              #   final: prev:
              #   let
              #     py = final.python313Packages;
              #     openvdbWithPython = prev.openvdb.overrideAttrs (old: {
              #       nativeBuildInputs = old.nativeBuildInputs ++ [ py.nanobind ];
              #       cmakeFlags = old.cmakeFlags ++ [
              #         "-DOPENVDB_BUILD_PYTHON_MODULE=ON"
              #         "-DUSE_NUMPY=ON"
              #         "-DOPENVDB_PYTHON_WRAP_ALL_GRID_TYPES=ON"
              #         "-Dnanobind_DIR=${py.nanobind}/${py.python.sitePackages}/nanobind/cmake"
              #       ];
              #     });
              #   in
              #   {
              #     blender = (prev.blender.override { openvdb = openvdbWithPython; }).overrideAttrs (old: {
              #       pythonPath = old.pythonPath ++ [ openvdbWithPython ];
              #     });
              #   }
              # )

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
