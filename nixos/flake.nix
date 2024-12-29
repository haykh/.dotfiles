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
      cfg = {
        user = "hayk";
        home = "/home/${cfg.user}";
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
              ./fw16/fw16.nix
              (import ./global.nix { inherit cfg; })
              ./modules/locale.nix
              ./modules/gnome.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users."${cfg.user}" = (import ./home.nix { inherit cfg; });
              }
            ];
          };
      };
    };
}
