{
  description = "Home Networking and desktops";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    vs-code-extensions.url = "github:nix-community/nix-vscode-extensions";
    disko.url = "github:nix-community/disko";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.adrian = import ./hosts/desktop/home.nix;
          }
        ];
      };
      nixosConfigurations.desktop_new = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          inputs.disko.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          ./hosts/desktop_new/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.adrian = import ./hosts/desktop_new/home.nix;
          }
        ];
      };
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.nixos-anywhere
          pkgs.sops
          pkgs.age
          pkgs.wireguard-tools
      ];
    };
  };
}
