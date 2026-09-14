{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/nixos
    ../../modules/nixos/hardware/nvidia.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "26.05";
}