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
        cp ${../../../assets/spicetify/user.css} $out/user.css
        cp ${../../../assets/spicetify/color.ini} $out/color.ini
      '';
    };
    wayland = true;
  };
}
