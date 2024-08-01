{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    tree
    sops
    gnupg
    pinentry
  ];


  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = "gtk2";
  };
}