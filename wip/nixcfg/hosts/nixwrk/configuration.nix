{ config, lib, pkgs, ... }:

{
	imports = [
		./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-16-7040-amd
    inputs.home-manager.nixosModules.default
	];

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "nixwrk";
	networking.wireless.enable = true;
# networking.networkmanager.enable = true;

	time.timeZone = "US/Eastern";

	i18n.defaultLocale = "en_US.UTF-8";
	console = {
		font = "Lat2-Terminus16";
		keyMap = "us";
	};

	services = {
		xserver = {
		enable = true;
		xkb.layout = "us";
		xkb.variant = "";
		};
		displayManager = {
			sddm = {
				enable = true;
				wayland.enable = true;
			};
		};
		openssh.enable = true;
	};

# Enable CUPS to print documents.
# services.printing.enable = true;

# Enable sound.
# hardware.pulseaudio.enable = true;
# OR
# services.pipewire = {
#   enable = true;
#   pulse.enable = true;
# };

	users = {users.hayk = { 
		isNormalUser = true;
		home = "/home/hayk";
		extraGroups = [ "wheel" ];
	};
	defaultUserShell = pkgs.zsh;
	};

	environment.systemPackages = with pkgs; [
		wget
			git
			curl
			neovim
			kitty
			firefox
			dolphin
			starship
			eza
			tldr
			nb
			ranger
	];

# programs.mtr.enable = true;
	programs = {
		gnupg = {
			agent = {
				enable = true;
				enableSSHSupport = true;
			};
		};
		hyprland = {
			enable = true;
			portalPackage = pkgs.xdg-desktop-portal-hyprland;
		};
		zsh = {
			enable = true;
		}
	};

	fonts.packages = with pkgs; [
		"Monaspice"
			(nerdfonts.override { fonts = [ "Monaspice" ]; })
	];


	system.copySystemConfiguration = true;

	system.stateVersion = "24.05";
}
