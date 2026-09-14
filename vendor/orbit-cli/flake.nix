{
  description = "Orbit CLI (fork of Caelestia dots CLI)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) genAttrs platforms lists systems;

    pkgsOf = nixpkgs.legacyPackages;
    systems' = lists.intersectLists platforms.linux systems.flakeExposed;
    eachSystem = genAttrs systems';
  in {
    formatter = eachSystem (system: pkgsOf.${system}.alejandra);

    packages = eachSystem (system: rec {
      orbit-cli = pkgsOf.${system}.callPackage ./default.nix {
        rev = self.rev or self.dirtyRev or "dev";
      };
      default = orbit-cli;
    });
  };
}
