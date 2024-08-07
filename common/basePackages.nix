{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    tree
    sops
    #gnupg
    gpg
    gpg-agent
    pinentry-tty
    #pinentry
    #pinentry-curses
  ];

  services.gog-agent.enable = true;
  services.gpg-agent.pinentryFlavor = "pinentry-tty";
  programs.gnupg.agent = {
    enable = true;
  };
  # programs.gnupg.agent = {
  #   enable = true;
  #   pinentryPackage = pkgs.pinentry-curses;
  #   enableSSHSupport = true;
  # };
}