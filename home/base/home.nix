{ myvars, pkgs, ... }:
{
  home.username = myvars.username;
  home.homeDirectory = "/home/${myvars.username}";

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  # GTK4 reads ~/.XCompose directly (or ~/.config/gtk-4.0/Compose first).
  # Its built-in table maps dead_acute+c → ć (X11 line 575). We override
  # to ç. No include needed: GTK merges file entries over its built-in table.
  home.file.".XCompose".text = ''
    <dead_acute> <c> : "ç"
    <dead_acute> <C> : "Ç"
  '';
}