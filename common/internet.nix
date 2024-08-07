{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    w3m
  ];


}