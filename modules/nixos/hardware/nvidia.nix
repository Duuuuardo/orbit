{ ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    branch = "legacy_580";
    nvidiaSettings = true;
    powerManagement.enable = true;
  };
}