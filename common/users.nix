# common/users.nix
{ config, pkgs, ... }:

{
    users.mutableUsers = false;
    
    users.users = {
        root = {
        initialPassword = "root";
        };

        adrian = {
            isNormalUser = true;
            password = "$6$LHbxg9QDCeflSqEx$VZuK00PzAFEQaI2uszoqvz8hlonxnU4NZ/tGTK0eB1wCi2hetSYnRymO65ebTFx2pH9MtbhVlrjbxX3AinAu/.";
            extraGroups = [ "wheel" ];
        };
    };
}