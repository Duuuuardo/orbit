{
  description = "Orbit desktop shell (fork of Caelestia dots shell)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    orbit-cli = {
      url = "path:../orbit-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    m3shapes = {
      url = "github:soramanew/m3shapes/32ad9ce328bb77ed349b40a3be10ee9ea610b8ab";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) genAttrs platforms modules lists systems;

    pkgsOf = nixpkgs.legacyPackages;
    systems' = lists.intersectLists platforms.linux systems.flakeExposed;
    eachSystem = genAttrs systems';
  in {
    formatter = eachSystem (system: pkgsOf.${system}.alejandra);

    packages = eachSystem (system: let
      pkgs = pkgsOf.${system};
    in rec {
      orbit-shell = pkgs.callPackage ./nix {
        rev = self.rev or self.dirtyRev or "dev";
        stdenv = pkgs.clangStdenv;
        quickshell = (inputs.quickshell.packages.${system}.default.override {
          withX11 = false;
          withI3 = false;
        }).overrideAttrs (oa: {
          
          buildInputs = (oa.buildInputs or []) ++ [ pkgs.qt6.qtmultimedia ];
          propagatedBuildInputs = (oa.propagatedBuildInputs or []) ++ [ pkgs.qt6.qtmultimedia ];
        });
        orbit-cli = inputs.orbit-cli.packages.${system}.default;
        m3shapes = inputs.m3shapes.packages.${system}.default;
      };
      with-cli = orbit-shell.override {withCli = true;};
      debug = orbit-shell.override {debug = true;};
      default = orbit-shell;
    });

    devShells = eachSystem (system: {
      default = let
        pkgs = pkgsOf.${system};
        shell = self.packages.${system}.orbit-shell;
        mkShell = pkgs.mkShell.override {stdenv = shell.stdenv;};
      in
        mkShell {
          inputsFrom = [shell shell.plugin shell.extras];
          packages = with pkgs; [clazy material-symbols rubik nerd-fonts.caskaydia-cove];
          ORBIT_XKB_RULES_PATH = "${pkgs.xkeyboard-config}/share/xkeyboard-config-2/rules/base.lst";
        };
    });

    homeManagerModules.default = modules.importApply ./nix/hm-module.nix self;
  };
}