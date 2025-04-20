let
  dir = ./.;

  entries = builtins.readDir dir;

  nixFiles = builtins.filter
    (name: builtins.match ".*\\.nix$" name != null && name != "default.nix")
    (builtins.attrNames entries);

in
  map (name: dir + "/${name}") nixFiles
