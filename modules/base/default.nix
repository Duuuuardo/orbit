{ ... }:
{
  imports = [
    ./users.nix
    ./system.nix
    ./nix.nix
    ./security.nix
    ./system-packages.nix
    ./fonts.nix
    ./hardware.nix
  ];
}