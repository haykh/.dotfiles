{

  description = "master flake";

  inputs = {
    nixpkgs = {
      url = "nixpkgs/nixos-24.11";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
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
      cfg = rec {
        user = "hayk";
        home = "/home/${user}";
        dotfiles = "${home}/.dotfiles";
        git = {
          username = "haykh";
          email = "haykh.astro@gmail.com";
        };
        shell_aliases = {
          vi = "nvim";
          vim = "nvim";
          ff = "fastfetch";
          nixbuild = "sudo nixos-rebuild switch --flake ${dotfiles}/nixos#$(hostname)";
          nixupd = "nix flake update --flake ${dotfiles}/nixos#$(hostname)";
          flakecfg = "$EDITOR ${dotfiles}/nixos/flake.nix";
          nixcfg = "$EDITOR ${dotfiles}/nixos/";
          cat = "bat -pp --theme=TwoDark";
          ll = "ls --long --header --time-style=long-iso";
          lt = "ls --tree --level 2 --icons=always --color";
          ld = "ls --long --header --time-style=long-iso --total-size";
          icat = "chafa -f kitty";
          rclone-reload = "systemctl --user restart mount-drives.service";
        };
        gtktheme = {
          accent = "#7295F6";
          main = {
            pkg = "fluent-gtk-theme";
            interface = "Fluent-Dark";
            env = "Fluent:dark";
          };
          icon = {
            pkg = "fluent-icon-theme";
            interface = "Fluent-dark";
          };
          cursor = {
            pkg = "capitaine-cursors-themed";
            interface = "Capitaine Cursors";
          };
          wallpaper = "${dotfiles}/wallpapers/blueish-sunrise.jpg";
        };
        bindings = {
          terminal = {
            binding = "<Super>t";
            action = "ghostty";
          };
          browser = {
            binding = "<Super>f";
            action = "zen";
          };
          nautilus = {
            binding = "<Super>e";
            action = "nautilus";
          };
          rofi-icons = {
            binding = "<Control><Super>i";
            action = "${dotfiles}/.config/rofi/apps/launch --nerdicons > /dev/null 2> &1";
          };
          calc = {
            binding = "<Control><Super>c";
            action = "${home}/.local/bin/crifo > /dev/null 2> &1";
          };
          refs = {
            binding = "<Control><Super>a";
            action = "${home}/.local/bin/llyfr ${home}/Documents/Literature/refs.bib ${home}/Documents/Literature > /dev/null 2> &1";
          };
          rofi-moji = {
            binding = "<Control><Super>j";
            action = "${dotfiles}/.config/rofi/apps/launch --emojis > /dev/null 2> &1";
          };
          rofi-drun = {
            binding = "<Control><Super>r";
            action = "${dotfiles}/.config/rofi/apps/launch --drun > /dev/null 2> &1";
          };
          largersize = {
            binding = "<Super>equal";
            action = "${dotfiles}/scripts/actions.sh --enlarge";
          };
          closewindow = {
            binding = "<Super>q";
            action = "${dotfiles}/scripts/actions.sh --close";
          };
          pickcolor = {
            binding = "<Control>Print";
            action = "${dotfiles}/scripts/actions.sh --pick-color";
          };
          open-slack = {
            binding = "<Super>s";
            action = "${dotfiles}/scripts/actions.sh --open slack";
          };
          open-email = {
            binding = "<Super>k";
            action = "${dotfiles}/scripts/actions.sh --open email";
          };
          screenshot-select = {
            binding = "Print";
            action = "${dotfiles}/scripts/actions.sh --screenshot select";
          };
          screenshot-full = {
            binding = "<Control>Print";
            action = "${dotfiles}/scripts/actions.sh --screenshot full";
          };
          screenshot-gui = {
            binding = "<Alt>Print";
            action = "${dotfiles}/scripts/actions.sh --screenshot gui";
          };
        };
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
          in
          nixpkgs.lib.nixosSystem rec {
            pkgs = import nixpkgs {
              system = settings.system;
              config.allowUnfree = true;
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
              (import ./modules/gnome.nix)
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "bak";
                home-manager.users.${cfg.user} = (
                  import ./home/home.nix {
                    inherit inputs cfg;
                    stateVersion = settings.stateVersion;
                    configuration = import ./hosts/fw16/config.nix { inherit pkgs; };
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
