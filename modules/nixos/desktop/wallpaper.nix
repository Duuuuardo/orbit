{ pkgs, ... }:
{
  environment.etc."backgrounds/gravitys-edge.mp4".source = ../../../assets/gravitys-edge.mp4;
  environment.etc."backgrounds/gravitys-edge.png".source = ../../../assets/gravitys-edge-preview.png;

  environment.systemPackages = with pkgs; [
    mpvpaper
  ];
}