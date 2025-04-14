{ config, pkgs, ... }:

{
  home.username = "adrian";
  home.homeDirectory = "/home/adrian";

  programs.zsh.enable = false;

  home.packages = with pkgs; [
    bat
    eza
    kdePackages.kate
    thunderbird
    discord
  ];


  programs.git = {
    enable = true;
    userName = "Adrian E";
    userEmail = "adrian@edelen.haus";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nano";
      push.autoSetupRemote = true;
    };

    aliases = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      lg = "log --oneline --graph --decorate";
    };
  };



  home.stateVersion = "24.05";
}
