{ config, lib, pkgs, ... }:

with lib;

{
  options.tofu.dev.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable Dev Tooling";
  };

  config = mkIf config.tofu.gaming.enable {

    environment.sessionVariables.NIXOS_OZONE_WL = "1"; #var for vscode wayland

    environment.systemPackages = with pkgs; [
        pkgs.sqlite-web

        (vscode-with-extensions.override {
            vscodeExtensions = with vscode-extensions; [
                ms-python.python
                bbenoist.nix
                arrterian.nix-env-selector
                ms-vscode.hexeditor
                #dotnet / jellyfin dev
                ms-dotnettools.csharp
                #alexcvzz.vscode-sqlite
                github.vscode-github-actions
                ms-dotnettools.csdevkit
                editorconfig.editorconfig
                ms-vscode-remote.remote-containers
                ms-vscode-remote.remote-ssh

            ];
        })
    ];
  };
}

