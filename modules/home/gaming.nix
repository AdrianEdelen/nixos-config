{ config, lib, pkgs, ... }:

with lib;

{
  options.tofu.gaming.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable gaming setup: Steam, Lutris, Mangohud.";
  };

  config = mkIf config.tofu.gaming.enable {
    #programs.gamemode.enable = true; # figure our gamemode later
    #programs.steam.enable = true;
        home.packages = with pkgs; [
        protonup-qt
        protontricks
        steam
        lutris
        gamemode
        mangohud
    ];

    #services.gamemode.enable = true;

  };
}
