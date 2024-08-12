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
      <sops-nix/modules/sops>
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

