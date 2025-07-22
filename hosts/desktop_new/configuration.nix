{ config, pkgs, lib, ...}:
{
    imports = [ ../../modules/common ];
    config = {
        #core configuration
        system.stateVersion = "25.05";
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
          hashedPasswordFile = config.sops.secrets.adrian_password_hash.path;
          openssh.authorizedKeys
        };
        users.groups.adrian = {};

        # filesystem configuration (reference disko config)
        fileSystems."/" = lib.mkForce {
            device = "/dev/disk/by-part-label/nixos";
            fsType = "ext4";
        };
        fileSystems."/boot" = lib.mkForce {
            device = "/dev/disk/by-part-label/boot";
            fsType = "vfat";
        };
        fileSystems."/home" = lib.mkForce {
            device = "/dev/disk/by-part-label/home";
            fsType = "ext4";
        };

        
        sops = {
            defaultSopsFile = ./secrets.yaml;
            gnupg.sshKeyPaths = [
                "/etc/ssh/ssh_host_ed25519_key"
            ];
            secrets.adrian_password_hash = {};
        };

    };
}