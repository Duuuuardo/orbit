{
  description = "Orbit: modular NixOS setup with Hyprland & Orbit Shell (inspired by ryan4yin/nix-config)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    orbit-shell = {
      url = "path:./vendor/orbit-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.orbit-cli.follows = "orbit-cli";
    };
    orbit-cli = {
      url = "path:./vendor/orbit-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    astra-airlock = {
      url = "path:./vendor/astra-airlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      myvars = import ./vars;

      mkHost = { hostname, user ? myvars.username, system ? "x86_64-linux", withGames ? false }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs self myvars; };
          modules = [
            ./hosts/${hostname}/default.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs self myvars; };
              home-manager.users.${user} = import ./home/hosts/${hostname}.nix;
            }
          ] ++ nixpkgs.lib.optionals withGames [
            ./modules/nixos/applications/games.nix
          ];
        };
    in {
      nixosConfigurations = {
        voyager = mkHost { inherit (myvars) hostname; };
      };
    };
}
