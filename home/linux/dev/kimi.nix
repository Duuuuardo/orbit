{ pkgs, ... }:
let
  version = "0.42.0";
  pname = "kimi-code";
in {
  home.packages = [
    (pkgs.stdenv.mkDerivation {
      inherit pname version;

      src = pkgs.fetchurl {
        url = "https://code.kimi.com/kimi-code/binaries/${version}/kimi-code-linux-x64";
        sha256 = "ebb4ef02d85fe0a29dda95a5a60bcd0608a28c1ff331d27e99be54b9d472e33d";
      };

      nativeBuildInputs = [ pkgs.autoPatchelfHook ];
      buildInputs = [ pkgs.stdenv.cc.cc.lib ];

      sourceRoot = ".";
      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;
      dontStrip = true;

      installPhase = ''
        runHook preInstall
        install -Dm755 $src $out/bin/kimi-code
        runHook postInstall
      '';
    })
  ];
}