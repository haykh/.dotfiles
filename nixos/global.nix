{ cfg }:

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
    users."${cfg.user}" = {
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
      vim
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
