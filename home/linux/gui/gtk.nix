{
  pkgs,
  ...
}:

let
  generator = ../../../../config/gen-orbit-themes.py;
  scheme = ../../../../config/misc/orbit/scheme.json;
  orbitNamed = ../../../../vendor/orbit-cli/src/orbit/data/schemes/orbit/default/dark.txt;

  gtkCss = pkgs.runCommand "orbit-gtk-theme" {
    nativeBuildInputs = [ pkgs.python3 ];
  } ''
    python3 ${generator} ${scheme} ${orbitNamed} ${../../../../vendor/orbit-cli/src/orbit/data/templates/gtk.css} gtk > $out
  '';
in {
  home.file = {
    ".config/gtk-3.0/gtk.css".source = gtkCss;
    ".config/gtk-4.0/gtk.css".source = gtkCss;
  };
}