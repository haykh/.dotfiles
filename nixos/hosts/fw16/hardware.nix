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

    # Bluetooth keyboards attach as virtual `uhid` devices, so udev mints no
    # /dev/input/by-id or by-path symlink for them at all. Noctalia's bongocat
    # widget only accepts paths under those two directories (or a bare
    # /dev/input/eventN, whose number shifts between boots), so give every
    # Bluetooth keyboard a stable by-id link keyed on its HID vendor/product.
    # Wired and USB-dongle keyboards already get one from udev's own rules.
    # The vendor/product live on the parent inputN device, and $attr{} does not
    # reliably reach a parent for a nested path like id/vendor, so stash them
    # on the parent (where ATTR{} is its own attribute) and import them on the
    # event node. ID_BUS/ID_INPUT_KEYBOARD are only set on the event node, so
    # the parent rule filters on bustype 0005 (BUS_BLUETOOTH) instead. The
    # third rule keeps a symlink appearing even if the import comes up empty.
    udev.extraRules = ''
      ACTION=="add|change", SUBSYSTEM=="input", KERNEL=="input*", ATTR{id/bustype}=="0005", ENV{BT_KBD_ID}="$attr{id/vendor}_$attr{id/product}"
      ACTION=="add|change", SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_BUS}=="bluetooth", ENV{ID_INPUT_KEYBOARD}=="1", IMPORT{parent}="BT_KBD_ID"
      ACTION=="add|change", SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_BUS}=="bluetooth", ENV{ID_INPUT_KEYBOARD}=="1", ENV{BT_KBD_ID}=="", ENV{BT_KBD_ID}="unknown"
      ACTION=="add|change", SUBSYSTEM=="input", KERNEL=="event*", ENV{ID_BUS}=="bluetooth", ENV{ID_INPUT_KEYBOARD}=="1", SYMLINK+="input/by-id/bluetooth-$env{BT_KBD_ID}-event-kbd"
    '';
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

  environment.etc."wpa_supplicant/eduroam-ca.cer".source = ../../assets/eduroam-ca.cer;
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
