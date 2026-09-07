{ pkgs, ... }:

{

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.resumeDevice = "/dev/disk/by-uuid/a17262c5-574b-4311-b688-656167afbf9a";
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
  # Disable PSR (0x10) and Panel Replay (0x400) on the DCN 3.1 display engine.
  # Without this the panel intermittently fails to relight after suspend/DPMS,
  # logging "REG_WAIT timeout ... dcn31_program_compbuf_size" — a known
  # Framework 16 AMD (Phoenix) resume bug. Costs a little idle battery.
  # boot.kernelParams = pkgs.lib.mkAfter [
  #   "amdgpu.dcdebugmask=0x410"
  # ];
}
