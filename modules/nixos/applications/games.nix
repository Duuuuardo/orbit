{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.prismlauncher ];
  programs.steam = {
    enable = true;

    gamescopeSession = {
      enable = true;
      args   = [ "-w" "1920" "-h" "1080" "-r" "60" "-f" ];
      steamArgs = [ "-tenfoot" "-pipewire-dmabuf" ];
    };

    remotePlay.openFirewall         = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable             = true;
  };

  hardware.steam-hardware.enable = true;

  services.joycond.enable = true;
}
