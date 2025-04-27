
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
  tofu.dev.enable = true;

  programs = {
    direnv = {
      enable = true;
      #enableFishIntegration = true;
      nix-direnv.enable = true;
    };
    starship = {
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
    fish = {
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


  };

  # xdg.configFile."konsolerc".source = ./dotfiles/konsolerc; <- example dotfile, where we create it

  home.stateVersion = "24.05";
}
