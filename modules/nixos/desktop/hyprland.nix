{ inputs, pkgs, ... }:
let
  hyprlandSession = pkgs.runCommand "hyprland-session" { meta.priority = 10; } ''
    mkdir -p $out/share/wayland-sessions
    cat > $out/share/wayland-sessions/hyprland.desktop <<EOF
    [Desktop Entry]
    Name=Hyprland
    Comment=Hyprland Wayland compositor
    Type=Application
    Exec=${pkgs.hyprland}/bin/Hyprland
    TryExec=${pkgs.hyprland}/bin/Hyprland
    X-Session-Type=wayland
    DesktopNames=Hyprland
    EOF
  '';
in
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.pathsToLink = [ "/share/wayland-sessions" ];

  environment.etc."xkb/symbols/us-pt".source = ../../../config/input/us-pt;

  environment.sessionVariables = {
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
    HYPRCURSOR_THEME = "Bibata-Modern-Classic";
    HYPRCURSOR_SIZE = "24";
  };

  environment.etc."environment".text = ''
    XCURSOR_THEME=Bibata-Modern-Classic
    XCURSOR_SIZE=24
    HYPRCURSOR_THEME=Bibata-Modern-Classic
    HYPRCURSOR_SIZE=24
  '';

  environment.systemPackages = [
    pkgs.bibata-cursors
    hyprlandSession
    inputs.orbit-shell.packages.${pkgs.stdenv.hostPlatform.system}.with-cli
    inputs.orbit-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}