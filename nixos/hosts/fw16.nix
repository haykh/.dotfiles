{
  config,
  lib,
  pkgs,
  ...
}:

{

  # system.stateVersion = stateVersion;
  # pkgs.stdenv.hostPlatform.system.stateVersion = stateVersion;

  # nixpkgs.hostPlatform = hostPlatform;

  networking.useDHCP = lib.mkDefault true;
  # networking.hostName = hostname;

  # settings for KDE Connect
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    # graphics = with pkgs; {
    #   extraPackages32 = [ driversi686Linux.amdvlk ];
    # };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libva-vdpau-driver
        libvdpau-va-gl
        mangohud
        gamescope
      ];
      extraPackages32 = with pkgs; [
        mangohud
        gamescope
      ];
    };
    keyboard.qmk.enable = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    sane.enable = true;
  };

  services = {
    xserver = {
      videoDrivers = [ "amdgpu" ];
    };
    fwupd.enable = true;
    udev.packages = [ pkgs.via ];
    # prevent wake up in backpack
    udev.extraRules = ''
      SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
      SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    '';
    fprintd.enable = true;
    power-profiles-daemon.enable = true;
    printing = {
      enable = true;
      drivers = [
        pkgs.gutenprint
        pkgs.brlaser
        pkgs.brgenml1lpr
        pkgs.brgenml1cupswrapper
      ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };

  environment.systemPackages = with pkgs; [
    amdgpu_top

    vulkan-tools
    clinfo
    mesa-demos
    powertop
    nvtopPackages.amd
    lm_sensors

    framework-tool
    linuxKernel.packages.linux_zen.framework-laptop-kmod
  ];

}
