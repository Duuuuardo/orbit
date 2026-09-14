{ pkgs, inputs, ... }:

{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    colorScheme = "orbit";
    theme = {
      name = "orbit";
      src = pkgs.runCommand "orbit-spicetify-theme" { } ''
        mkdir -p $out
        cp ${../../../config/misc/spicetify/user.css} $out/user.css
        cp ${../../../config/misc/spicetify/color.ini} $out/color.ini
      '';
    };
    wayland = true;
  };
}
