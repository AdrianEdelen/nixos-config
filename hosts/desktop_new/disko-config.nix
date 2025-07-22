{ lib, ... }:
{
  disko.devices = {
    disk = {
      sda = { 
        type = "disk";
        device = "/dev/sda"; 
        content = {
          type = "table";
          format = "gpt"; 
          partitions = [
            {
              name = "boot";
              start = "1MiB";
              end = "512MiB";
              content = {
                type = "filesystem";
                format = "vfat"; 
                mountpoint = "/boot";
              };
            }
            {
              name = "nixos";
              start = "512MiB";
              end = "100%"; 
              content = {
                type = "filesystem";
                format = "ext4"; 
                mountpoint = "/";
              };
            }
          ];
        };
      };
      sdb = { 
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "filesystem";
          format = "ext4"; 
          mountpoint = "/home";
        };
      };
    };
  };
}