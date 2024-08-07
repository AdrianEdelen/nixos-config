{ config, lib, pkgs, ... }:

let
  usersConfig = import ../../../common/users.nix;
  sopsSecrets = lib.mapAttrs (userName: userConfig: {
    file = ../../../keys/"${userName}_id_ed25519.sops"; # Path to your encrypted SSH private key
    destination = "/home/${userName}/.ssh/id_ed25519";
    user = userName;
    group = userName;
    mode = "0600";
  }) usersConfig.users;
in
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

  environment.variables.EDITOR = "vim";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = lib.mkDefault "nixos";
  networking.networkmanager.enable = lib.mkDefault false;
  time.timeZone = lib.mkDefault "UTC";

  sops.

  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  system.stateVersion = "24.05"; 

}

