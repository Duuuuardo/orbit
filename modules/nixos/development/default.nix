{ pkgs, ... }:
{
  imports = [
    ./languages.nix
    ./compilers.nix
  ];
}