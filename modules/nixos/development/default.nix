{ pkgs, ... }:
{
  imports = [
    ./languages.nix
    ./compilers.nix
    ./appimage.nix
  ];
}