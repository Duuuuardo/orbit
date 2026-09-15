{ myvars, pkgs, ... }:
{
  home.username = myvars.username;
  home.homeDirectory = "/home/${myvars.username}";

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  # LibX11 Compose kept as absolute store path (NixOS has no /usr/share/X11/locale,
  # so "include %L" would silently fail and dead keys would break in GTK apps).
  # Overrides come AFTER the include so they win over the base "ç"/"ć" bindings.
  home.file.".XCompose".text = ''
    include "${pkgs.xorg.libX11}/share/X11/locale/en_US.UTF-8/Compose"

    <dead_acute> <c> : "ç"
    <dead_acute> <C> : "Ç"
  '';
}