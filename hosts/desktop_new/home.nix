{ config, pkgs, ... }:
{
  home.stateVersion = "25.05";

  programs.ssh = {
    enable = true;
    authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGAx3hpEtbFlli31t70VqJ/7enknFbtlIR3fpa5vTXBM adrian@box" # <--- REPLACE THIS with your actual public key
    ];
  };
}
