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


  services.gnupg.agent = {
    enable = true;
    defaultCacheTtl = 600;
    maxCacheTtl = 7200;
    pinentryFlavor = "gtk2";
  };
}