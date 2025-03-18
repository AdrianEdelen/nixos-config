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

  environment.variables.EDITOR = "vim";

  networking.hostName = lib.mkDefault "box";


  system.stateVersion = "24.05"; 
}