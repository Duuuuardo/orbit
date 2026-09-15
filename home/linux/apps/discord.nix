{ pkgs, ... }:
let
  # Discord (Electron/Chromium) only honors custom ~/.XCompose sequences when
  # running on the X11 (XWayland) ozone platform. Native Wayland uses its
  # hardcoded compose table: ' + c => ć instead of ç. We force X11 by setting
  # ELECTRON_OZONE_PLATFORM_HINT, exposing a "discord-x11" wrapper and a desktop
  # entry that takes precedence over the stock one.
  discord-x11 = pkgs.writeShellScriptBin "discord-x11" ''
    export ELECTRON_OZONE_PLATFORM_HINT=x11
    exec ${pkgs.discord}/bin/discord "$@"
  '';
in
{
  home.packages = [ pkgs.discord discord-x11 ];

  xdg.desktopEntries.discord = {
    name = "Discord";
    exec = "discord-x11 %U";
    icon = "discord";
    comment = "All-in-one cross-platform voice and text chat for gamers";
    mimeType = [ "x-scheme-handler/discord" ];
    type = "Application";
    categories = [ "Network" "InstantMessaging" ];
  };
}