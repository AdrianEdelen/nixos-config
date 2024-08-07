# flake.nix
{
    description = "My NixOS configuration with Flakes";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        sops-nix.url = "github:Mic92/sops-nix";
    };

    outputs = { self, nixpkgs, sops-nix }: {
        nixosConfigurations = {
            # base-x86_64 = nixpkgs.lib.nixosSystem {
            #     system = "x86_64-linux";
            #     modules = [
            #         sops-nix.nixosModules.sops
            #         ./configurations/base-x86-64/configuration.nix
            #     ];
            # };
            vm-tty = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    sops-nix.nixosModules.sops
                    ./configurations/base-x86-64/vm/configuration.nix
                    ./configurations/base-x86064/vm/vm-tty/configuration.nix
                ];
            };
            vm-xfce = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    sops-nix.nixosModules.sops
                    ./configurations/base-x86-64/vm/configuration.nix
                    ./configurations/base-x86-64/vm/vm-xfce/configuration.nix
                ];
            };
        };
    };
}
