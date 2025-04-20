{ config, lib, ... }:

with lib;

{
  options.tofu.bluetooth.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable Bluetooth.";
  };

  config = mkIf config.tofu.gaming.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;

  };
}
