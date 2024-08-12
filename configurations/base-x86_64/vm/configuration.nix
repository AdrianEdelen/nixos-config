{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ../../../common/users.nix
      ../../../common/basePackages.nix
      ../../../common/time.nix
      ../../../common/dev.nix
      ../../../common/internet.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    nfs-utils
  ];

  #TODO how to make this generic? e.g. what if user name changes
  fileSystems."/home/adrian" = {
    device = "192.168.1.41:/mnt/user/Adrian"; #nfs share on gary
    fsType = "nfs";
  };
  
  #TODO why is zsh being a bee-sh
  #programs.zsh.enable = true;
  

  environment.variables.EDITOR = "vim";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = lib.mkDefault "nixos";
  networking.networkmanager.enable = lib.mkDefault false;
  time.timeZone = lib.mkDefault "UTC";



  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  system.stateVersion = "24.05"; 

}

