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

  nix.settings.connect-timeout = 5;
  nix.settings.stalled-download-timeout = 20;
  nix.settings.fallback = true;

  nix.settings.extra-substituters = [
    "https://hyprland.cachix.org"
    "https://noctalia.cachix.org"
    "https://vicinae.cachix.org"
    "https://codex-cli.cachix.org"
    "https://devenv.cachix.org"
  ];
  nix.settings.extra-trusted-public-keys = [
    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
    "codex-cli.cachix.org-1:1Br3H1hHoRYG22n//cGKJOk3cQXgYobUel6O8DgSing="
    "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
  ];

  nix.settings.keep-outputs = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "45min";
    options = "--delete-older-than 30d";
  };

  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
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
        "networkmanager"
        "dialout"
        "input"
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
