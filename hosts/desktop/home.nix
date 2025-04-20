
{ config, pkgs, ... }:

{

  imports = import ../../modules/home;


  home.packages = with pkgs; [
    bat
    eza
    kdePackages.kate
    thunderbird
    discord
    btop
    signal-desktop-bin
  ];

  tofu.gaming.enable = true;
  programs.git = {
    enable = true;
    userName = "Adrian E";
    userEmail = "adrian@edelen.haus";
#
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
  programs.fish = {
  enable = true;
  shellInit = ''
    function nix-switch
        set flake $argv[1]

        if test -z "$flake"
            echo "Usage: nix-switch <flake> [-i]"
            return 1
        end

        set impure_flag ""
        if contains -i -- -i $argv
            set impure_flag "--impure"
        end

        nixos-rebuild switch --flake ~/Documents/nixos-config#$flake $impure_flag
    end
  '';
};


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
