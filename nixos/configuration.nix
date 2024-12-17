{
  pkgs,
  ...
}:

{

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking.networkmanager.enable = true;
  services.xserver.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };
  services.xserver.xkb = {
    layout = "us";
    options = "grp:win_space_toggle";
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    libinput.enable = true;
    openssh.enable = true;
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.hayk = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  programs = {
    firefox.enable = true;
    zsh.enable = true;
  };

  environment = with pkgs; {
    shells = [ zsh ];
    systemPackages = [

      # tools
      bc
      wget
      curl
      vim
      unzip
      wl-clipboard
      killall
      xclip

      # system
      docker
      docker-compose

    ];
  };

  system.stateVersion = "24.11"; # Do Not Change

}
