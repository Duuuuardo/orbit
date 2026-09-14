{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    rubik
    material-symbols
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
  ];
}