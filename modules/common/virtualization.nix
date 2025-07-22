{ config, pkgs, lib, ... }:

{
  options.common.vm.hypervisor = lib.mkOption {
    type = lib.types.enum [ "none" "qemu" "vmware" "virtualbox" ];
    default = "none";
    description = ''
      Selects the hypervisor integration to enable for this system.
      "none" disables all hypervisor-specific features.
    '';
  };

  config = lib.mkMerge [
    (lib.mkIf (config.common.vm.hypervisor == "qemu") {
      services.qemuGuest.enable = true;
    })
    #services.vmware.enable = lib.mkIf (config.common.vm.hypervisor == "vmware") true;
    #services.virtualboxGuest.enable = lib.mkIf (config.common.vm.hypervisor == "virtualbox") true;
  ];
}
