{
  stateVersion,
  hostPlatform,
  hostname,
}:

{
  config,
  lib,
  pkgs,
  ...
}:

{

  system.stateVersion = stateVersion;

  imports = [
    ./fw16/disks.nix
    ./fw16/boot.nix
  ];
  nixpkgs.hostPlatform = hostPlatform;

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = hostname;

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    # graphics = with pkgs; {
    #   enable32Bit = true;
    #   extraPackages = [ amdvlk ];
    #   extraPackages32 = [ driversi686Linux.amdvlk ];
    # };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        mangohud
        gamescope
        # amdvlk
      ];
      extraPackages32 = with pkgs; [
        mangohud
        gamescope
      ];
    };
    keyboard.qmk.enable = true;
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
  };

  environment.systemPackages = with pkgs; [
    amdgpu_top

    vulkan-tools
    clinfo
    glxinfo
    powertop
    nvtopPackages.amd
    lm_sensors

    framework-tool
    linuxKernel.packages.linux_zen.framework-laptop-kmod
  ];

}
