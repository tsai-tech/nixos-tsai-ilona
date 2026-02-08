{
  description = "NixOS + Home Manager setup for Mikhail";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    awww.url = "git+https://codeberg.org/LGFae/awww";
  };

  outputs = { self, nixpkgs, home-manager, awww, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Общие модули для всех конфигураций
      commonModules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.leet = import ./home.nix;
        }
      ];
    in
    {
      # Основная конфигурация для реального железа
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit awww; };
        modules = commonModules;
      };

      # Конфигурация для тестирования в VMware
      nixosConfigurations.nixos-vmware = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = commonModules ++ [ ./vmware.nix ];
      };
    };
}
