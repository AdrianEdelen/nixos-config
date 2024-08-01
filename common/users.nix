# common/users.nix
{ config, pkgs, ... }:

{
    users.users.adrian = {
        isNormalUser = true;
        password = "$y$j9T$JCcuaa0bALWxON4dBQExy0$A5PHtEVd8n5s1Hc7LYVx6IPx7WIP9ZhBeRrGbFZcFf3";
        extraGroups = [ "wheel" ];
    }
}