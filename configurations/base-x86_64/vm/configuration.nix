{ config, lib, pkgs, ... }:

let
  usersConfig = import ../../../common/users.nix;
  sopsSecrets = lib.mapAttrs (userName: userConfig: {
    file = "../../../keys/${userName}_ssh"; 
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

  #I don't think we need this
  #apply sops-nix ssh keys
  # environment.etc = lib.mapAttrs' (userName: secret: {
  #   source = secret.file;
  #   target = secret.destination;
  #   user = secret.user;
  #   group = secret.group;
  #   mode = secret.mode;
  # }) sopsSecrets;

  #set ssh agent
  #i am not sure if the agent is set already.
  systemd.user.ssh-agent = {
    enable = true;
    environment.SSH_AUTH_SOCK = "${config.systemd.user.ssh-agent.unit.Sockets.SSH_AUTH_SOCK}";
  };

  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  system.stateVersion = "24.05"; 

}

