# flake.nix
{
    description = "My NixOS configuration with Flakes";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        sops-nix.url = "github:Mic92/sops-nix";
    };

    outputs = { self, nixpkgs }: {
        nixosConfigurations = {
            base-x86_64 = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    sops-nix.nixosModules.sops
                    ./configurations/base/configuration.nix
                ];
            };
            vm = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configurations/base-x86_64/configuration.nix
                    ./configurations/vm/configuration.nix
                ];
            };
        };
    };
}
