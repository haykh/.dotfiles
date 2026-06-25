{
  config,
  lib,
  user,
  ...
}:

let
  cfg = config.my.virtualisation.kvm;
in
{

  options.my.virtualisation.kvm.enable = lib.mkEnableOption "KVM / libvirt virtualization";

  config = lib.mkIf cfg.enable {

    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = [ user ];
    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

  };

}
