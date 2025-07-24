{ pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/iso-image.nix> ];

  system.stateVersion = "25.05";
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "no";
  users.users.nixos.authorizedKeys.keyFiles = [
            ../../ssh/public-keys/workstation.pub
          ];
}