{ ... }:
{
  hardware.cpu.amd.updateMicrocode = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
}
