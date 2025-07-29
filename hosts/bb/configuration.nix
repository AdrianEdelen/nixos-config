{ config, pkgs, lib, ...}:
{
    imports = [ 
        ../../modules/common
        ./disko-config.nix ];
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
          openssh.authorizedKeys.keyFiles = [
            ../../ssh/public-keys/workstation.pub
          ];
        };
        users.groups.adrian = {};
        
        sops = {
            defaultSopsFile = ./secrets.yaml;
            age.keyFile = "/var/lib/sops/age/keys.txt";
            secrets.adrian_password_hash = {};
        };
    };
}