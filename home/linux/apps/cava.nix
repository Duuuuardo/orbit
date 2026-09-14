{ pkgs, ... }:
{
  home.packages = [ pkgs.cava ];

  home.file.".config/cava/config".text = ''
    [general]
    framerate = 60
    autosens = 1
    bars = 24
    lower_cutoff_freq = 50
    higher_cutoff_freq = 10000

    [output]
    method = ncurses
    channels = mono
    stereo = false
    foreground = #ac73ff
    background = #131317

    [smoothing]
    monstercat = 1
    waves = 1
    gravity = 100
  '';
}