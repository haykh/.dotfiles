{
  config,
  lib,
  pkgs,
  ...
}:

{

  networking.useDHCP = lib.mkDefault true;

  boot.supportedFilesystems = [ "ntfs" ];

  services.udisks2.enable = true;

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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

    framework.enableKmod = true;
  };

  services = {
    xserver = {
      videoDrivers = [ "amdgpu" ];
    };
    fwupd.enable = true;
    udev.packages = [ pkgs.via ];
    # prevent wake up in backpack
    # udev.extraRules = lib.mkAfter ''
    #   SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    #   SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled", ATTR{driver/1-1.1.1.4/power/wakeup}="disabled"
    # '';
    fprintd.enable = true;
    power-profiles-daemon.enable = true;

    # Power button (single press) hibernates; lid close suspends. A long press
    # still powers off. Hibernate uses the swap partition (boot.resumeDevice
    # below) — note swap (~30G) < RAM (38G), so hibernate can fail if in-use
    # memory exceeds the swap size.
    logind.settings.Login = {
      HandlePowerKey = "hibernate";
      HandlePowerKeyLongPress = "poweroff";
      HandleLidSwitch = "suspend";
      HandleLidSwitchExternalPower = "suspend";
    };
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

  environment.etc."wpa_supplicant/eduroam-ca.cer".source = ./eduroam-ca.cer;
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
