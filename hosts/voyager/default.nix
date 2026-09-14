{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/nixos
    ../../modules/nixos/hardware/laptop.nix
  ];

  boot.loader.systemd-boot.enable  = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.loader.systemd-boot.configurationLimit = 2;

  zramSwap.enable = true;

  system.stateVersion = "26.05";
}
