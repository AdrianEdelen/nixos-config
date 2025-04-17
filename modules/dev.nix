{ config, lib, pkgs, ... }:

with lib;

{
  options.tofu.dev.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable Dev tools";
  };

  config = mkIf config.tofu.gaming.enable {
    #add dev stuff here.
  };
}
