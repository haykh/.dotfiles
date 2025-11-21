{
  pkgs,
  home,
  user,
  ...
}:

{

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.trusted-users = [
    "root"
    user
  ];

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "45min";
    options = "--delete-older-than 30d";
  };

  networking.networkmanager.enable = true;
  services.xserver.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
    libinput.enable = true;
    openssh.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    daemon.settings = {
      data-root = "${home}/docker";
    };
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users."${user}" = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
        "kvm"
      ];
    };
  };

  programs = {
    zsh.enable = true;
  };

  environment = with pkgs; {
    shells = [ zsh ];
    systemPackages = [

      # tools
      vim
      wl-clipboard
      killall
      xclip

      # system
      docker
      docker-compose

      # browser
      ungoogled-chromium

    ];
  };

}
