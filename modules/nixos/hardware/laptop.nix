{ ... }:
{
  hardware.cpu.intel.updateMicrocode = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    branch = "legacy_580";
    nvidiaSettings = true;
    powerManagement.enable = true;

    prime.offload = {
      enable = true;
      enableOffloadCmd = true;
    };

    # TODO: fill after running nixos-generate-config
    # prime.intelBusId = "PCI:0:2:0";
    # prime.nvidiaBusId = "PCI:1:0:0";
  };
}
