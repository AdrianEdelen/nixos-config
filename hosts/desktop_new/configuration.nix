{ config, pkgs, ...}:
{
    imports = [ ../../modules/common ];
    config = {
        #core configuration
        networking.hostName = "bb";
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;
        networking.networkmanager.enable = true;
        services.openssh = {
            enable = true;
            settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
            };
        };
        time.timeZone = "America/New_York";
        
        #custom options
        common.vm.hypervisor = "qemu";
        
        # User configuration
        users.users.adrian = {
          isNormalUser = true;
          group = "adrian";
          extraGroups = [ "wheel" ];
        };
        users.groups.adrian = {};

        # filesystem configuration (reference disko config)
        fileSystems."/" = {
            device = "/dev/disk/by-part-label/nixos";
            fsType = "ext4";
        };
        fileSystems."/boot" = {
            device = "/dev/disk/by-part-label/boot";
            fsType = "vfat";
        };
        fileSystems."/home" = {
            device = "/dev/disk/by-part-label/home";
            fsType = "ext4";
        };
        
        system.stateVersion = "25.05";
    };
}