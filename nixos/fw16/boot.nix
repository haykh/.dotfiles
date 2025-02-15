{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_6_6;
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
  boot.kernelParams = [
    "amdgpu.abmlevel=0"
    # "amdgpu.sg_display=0"
    # "amdgpu.dcdebugmask=0x400"
  ];
  boot.extraModulePackages = [ ];
}
