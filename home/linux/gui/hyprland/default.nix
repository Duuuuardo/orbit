{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";

    extraConfig = ''
      ${builtins.readFile ./config.lua}
      ${builtins.readFile ./animations.lua}
      ${builtins.readFile ./decoration.lua}
      ${builtins.readFile ./rules.lua}
      ${builtins.readFile ./execs.lua}
      ${builtins.readFile ./bindings.lua}
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
