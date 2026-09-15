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

  # lockKernelModules prevents module loading after boot, so ext4 must be
  # loaded during the initrd stage for /mnt/games to mount.
  boot.initrd.kernelModules = [ "ext4" ];

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/35e1fa3f-1149-411e-97f4-f1605ee175dc";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/games 0755 eduardo users - -"
  ];

  # TODO: add hardware-configuration.nix after running nixos-generate-config
  system.stateVersion = "26.05";
}
