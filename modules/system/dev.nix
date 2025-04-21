{ config, lib, pkgs, ... }:

with lib;

{
  options.tofu.dev.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable Dev Tooling";
  };

  config = mkIf config.tofu.gaming.enable {
    environment.systemPackages = with pkgs; [
        (vscode-with-extensions.override {
            vscodeExtensions = with vscode-extensions; [
                ms-python.python
            ];
        })
    ];
  };
}
