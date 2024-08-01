# flake.nix
{
    description = "My NixOS configuration with Flakes";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs }: {
        nixosConfigurations = {
            base-x86_64 = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux"
                modules = [
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
