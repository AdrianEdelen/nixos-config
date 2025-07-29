{ pkgs, lib, ... }:

{
  isoImage.isoName = "custom-vm-live.iso";
  system.stateVersion = "25.05";
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password";
  users.users.root.openssh.authorizedKeys.keyFiles =
    let
      pubkeyDir = ../../ssh/public-keys;
    in
    builtins.map (file: pubkeyDir + "/${file}") (
      lib.filter (file: lib.hasSuffix ".pub" file) (
        builtins.attrNames (builtins.readDir pubkeyDir)
      )
  );
}