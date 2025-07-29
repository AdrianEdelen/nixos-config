{ pkgs, ... }:

{
  isoImage.isoName = "custom-vm-live.iso";
  system.stateVersion = "25.05";
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  users.users.root.openssh.authorizedKeys.keyFiles = [
            ../../ssh/public-keys/workstation.pub
          ];
}