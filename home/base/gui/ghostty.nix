{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 12;
      background-opacity = 0.78;
      background-blur-radius = 25;
      window-padding-x = 25;
      window-padding-y = 25;
      cursor-style = "bar";
      bold-is-bright = false;
      scrollback-limit = 10000;

      background = "#131317";
      foreground = "#e5e1e7";
      cursor-color = "#e5e1e7";
      cursor-text = "#131317";
      selection-background = "#353438";
      selection-foreground = "#e5e1e7";

      palette = [
        "0=#353434"
        "1=#ac73ff"
        "2=#44def5"
        "3=#ffdcf2"
        "4=#99aad8"
        "5=#b49fea"
        "6=#9dceff"
        "7=#e8d3de"
        "8=#ac9fa9"
        "9=#c093ff"
        "10=#89ecff"
        "11=#fff0f6"
        "12=#b5c1dd"
        "13=#c9b5f4"
        "14=#bae0ff"
        "15=#ffffff"
      ];
    };
  };
}
