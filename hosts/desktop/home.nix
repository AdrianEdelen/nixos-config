
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
    protonup-qt
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

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      git_branch = {
       symbol = "🌱 ";
       };
    };
  };
  programs.fish.enable = true;

  # xdg.configFile."konsolerc".source = ./dotfiles/konsolerc; <- example dotfile, where we create it
#   xdg.userDirs = {
#     enable = true;
#
#     desktop = null;
#     documents = "${config.home.homeDirectory}/Documents";
#     download = "${config.home.homeDirectory}/Downloads";
#     music = null;
#     pictures = null;
#     publicShare = null;
#     templates = null;
#     videos = null;
#   };

  home.stateVersion = "24.05";
}
#ok so i probably won't mess with those files for now.

#my next question, is how can i force apps to not pollute my home dir.
