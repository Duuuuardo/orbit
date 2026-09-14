{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    extraConfig = ''
      ${builtins.readFile ../../../../config/hyprland/config.lua}
      ${builtins.readFile ../../../../config/hyprland/animations.lua}
      ${builtins.readFile ../../../../config/hyprland/decoration.lua}
      ${builtins.readFile ../../../../config/hyprland/group.lua}
      ${builtins.readFile ../../../../config/hyprland/gestures.lua}
      ${builtins.readFile ../../../../config/hyprland/rules.lua}
      ${builtins.readFile ../../../../config/hyprland/execs.lua}
      ${builtins.readFile ../../../../config/hyprland/bindings.lua}
    '';
  };

  

  

  

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;

    x11.enable = true;
    gtk.enable = true;
    hyprcursor.enable = true;
    dotIcons.enable = true;
  };
}
