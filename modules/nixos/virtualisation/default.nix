{ pkgs, myvars, ... }:
{
  imports = [
    ./docker.nix
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
    };
  };

  users.users.${myvars.username}.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [
    virt-manager
    libvirt
    qemu
  ];
}