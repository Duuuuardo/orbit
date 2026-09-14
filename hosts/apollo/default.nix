{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base
    ../../modules/nixos
    ../../modules/nixos/hardware/desktop.nix
  ];

  # Dual boot: NixOS + Windows
  boot.loader.systemd-boot.enable  = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;
  boot.loader.systemd-boot.configurationLimit = 3;

  # TODO: add hardware-configuration.nix after running nixos-generate-config
  system.stateVersion = "26.05";
}
