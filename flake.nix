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
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };

  outputs = { self, nixpkgs, home-manager, nixos-facter-modules, ... } @inputs:
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
      nixosConfigurations.bb = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          inputs.disko.nixosModules.default
          inputs.sops-nix.nixosModules.sops
          ./hosts/bb/configuration.nix
          nixos-facter-modules.nixosModules.facter
          { config.facter.reportPath = ./facter.json; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.adrian = import ./hosts/bb/home.nix;
          }
        ];
      };
      nixosConfigurations.live = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ 
          (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
          ./hosts/live/live.nix 
          ({ pkgs, ... }: {
          nix.settings.experimental-features = [ "nix-command" "flakes" ];
          nix.registry.nixpkgs.flake = nixpkgs;
          })
        ];
      };
      packages.${system}.live = self.nixosConfigurations.live.config.system.build.isoImage;
      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.nixos-anywhere
          pkgs.sops
          pkgs.age
          pkgs.wireguard-tools
          pkgs.nixos-generators
          pkgs.openssl
      ];
    };
  };
}
