{ config, pkgs, ... }:

{
  home.username = "adrian";
  home.homeDirectory = "/home/adrian";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bat
    eza
    starship
    kdePackages.kate
    thunderbird
    discord
  ];

  programs.git.enable = true;
  programs.zsh.enable = true;

  home.stateVersion = "24.05";
}
