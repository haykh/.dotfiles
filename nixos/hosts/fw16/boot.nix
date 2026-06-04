{ pkgs, ... }:

{

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.kernelPatches = [
  #   {
  #     name = "btmtk-fix-wmt-event-size";
  #     patch = ./patches/btmtk-fix-wmt-event-size.patch;
  #   }
  # ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "thunderbolt"
    "usb_storage"
    "usbhid"
    "uas"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "amdgpu"
    "kvm-amd"
  ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = pkgs.lib.mkAfter [
    "amdgpu.dcdebugmask=0x410"
  ];
}
