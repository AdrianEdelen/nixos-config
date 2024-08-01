{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
  ];

  
  environment.etc."gitconfig".text = ''
    [user]
        name = "adrian"
        email = "adrian@edelen.haus"
    [core]
        editor = "vim"
    [color]
        ui = auto
    [alias]
        co = checkout
        br = branch
        ci = commit
        st = status
  '';

}