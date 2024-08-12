# common/users.nix
{ config, pkgs, ... }:

{



    users.mutableUsers = false;
    
    users.users = {
        root = {
        hashedPassword = "$6$LHbxg9QDCeflSqEx$VZuK00PzAFEQaI2uszoqvz8hlonxnU4NZ/tGTK0eB1wCi2hetSYnRymO65ebTFx2pH9MtbhVlrjbxX3AinAu/.";
        };

        adrian = {
            isNormalUser = true;
            hashedPassword = "$6$LHbxg9QDCeflSqEx$VZuK00PzAFEQaI2uszoqvz8hlonxnU4NZ/tGTK0eB1wCi2hetSYnRymO65ebTFx2pH9MtbhVlrjbxX3AinAu/.";
            extraGroups = [ "wheel" "networkmanager" ];
            openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJyWYKha5v+ubkEDWg9ak4iop/5ghspe8vV8poRLfj81 adrian@edelen.haus" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPvAS6S17aYbEVztdQxNkfS/ziTg6JVx4uBLzaccmvfm JuiceSSH" ];
            home = "/home/adrian";
            shell = pkgs.zsh;            
        };
    };
}