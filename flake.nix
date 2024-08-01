# flake.nix
{
    description = "My NixOS configuration with Flakes";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    outputs = { self, nixpkgs }: {
        nixosConfigurations = {
            vm = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configurations/vm/configuration.nix
                ];
            };
        };
    };
}
