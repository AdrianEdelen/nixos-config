{ config, lib, ... }:

with lib;

{
  options.tofu.gaming.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable system-level gaming services.";
  };

  config = mkIf config.tofu.gaming.enable {
    #services.gamemode.enable = true;
    programs.steam.enable = true;
  };
}
