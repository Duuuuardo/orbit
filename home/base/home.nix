{ myvars, pkgs, ... }:
{
  home.username = myvars.username;
  home.homeDirectory = "/home/${myvars.username}";

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}