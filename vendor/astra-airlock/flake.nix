{
  description = "A clean M3 Quickshell frontend for greetd";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    quickshell = {
      

      

      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell?rev=2d3b3e9c70ef380dff751b61d334dc88df016c29";
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
    forAllSystems = fn:
      nixpkgs.lib.genAttrs nixpkgs.lib.platforms.linux (
        system: fn nixpkgs.legacyPackages.${system}
      );
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);

    packages = forAllSystems (pkgs: rec {
      astra-airlock = pkgs.callPackage ./nix {
        m3shapes = inputs.m3shapes.packages.${pkgs.stdenv.hostPlatform.system}.default;
        airlockVersion = "0.20250115";
        

        

        

        

        quickshell = (inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
          withX11 = false;
          withI3 = false;
        }).overrideAttrs (oa: {
          buildInputs = (oa.buildInputs or []) ++ [
            pkgs.qt6.qtmultimedia
            pkgs.qt6.qtimageformats
            inputs.m3shapes.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
          propagatedBuildInputs = (oa.propagatedBuildInputs or []) ++ [ pkgs.qt6.qtmultimedia ];
        });
      };
      default = astra-airlock;
    });

    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          cmake
          ninja
          pkg-config
          qt6.qtbase
          qt6.qtdeclarative
          qt6.qtquick3d
          cage
          greetd.greetd
        ];
      };
    });

    nixosModules.default = { config, lib, pkgs, ... }:
      with lib;
      let
        cfg = config.services.greetd.astraAirlock;
      in {
        options.services.greetd.astraAirlock = {
          enable = mkEnableOption "Airlock display manager frontend";
          package = mkOption {
            type = types.package;
            default = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
            description = "The astra-airlock package to use.";
          };
          compositor = mkOption {
            type = types.enum [ "cage" "hyprland" ];
            default = "cage";
            description = "The Wayland compositor to run the greeter in.";
          };
        };

        config = mkIf cfg.enable {
          services.greetd = {
            enable = true;
            settings = {
              default_session = {
                command = if cfg.compositor == "cage" then
                  "${pkgs.cage}/bin/cage -s -- ${cfg.package}/bin/astra-airlock >/dev/null 2>&1"
                else
                  "${pkgs.hyprland}/bin/Hyprland >/dev/null 2>&1";
                user = "greeter";
              };
            };
          };

          systemd.tmpfiles.rules = [
            "d /var/cache/astra-airlock 0755 greeter greeter -"
          ];
        };
      };
  };
}
