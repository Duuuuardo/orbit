{ myvars, ... }:
{
  home.username = myvars.username;
  home.homeDirectory = "/home/${myvars.username}";

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.file.".XCompose".text = ''
    include "%L"

    <dead_acute><c> : "ç"
    <dead_acute><C> : "Ç"
  '';
}