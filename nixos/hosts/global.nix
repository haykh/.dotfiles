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
  # Don't let NetworkManager manage docker/container virtual interfaces.
  # Otherwise NM tracks docker0 and may try to activate wifi profiles on it
  # ("No suitable device found ... docker0"), which breaks connecting/forgetting
  # networks from UIs (e.g. Noctalia) that don't pin the device explicitly.
  networking.networkmanager.unmanaged = [
    "interface-name:docker*"
    "interface-name:veth*"
    "interface-name:br-*"
  ];
  services.xserver.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
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
        # Grants NetworkManager connection management without per-action polkit
        # prompts — needed for managing wifi from Noctalia's UI.
        "networkmanager"
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
    ];
  };

}
