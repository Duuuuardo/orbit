{
  pkgs,
  ...
}:

let
  generator = ./gen-orbit-themes.py;
  scheme = ../../../assets/orbit/scheme.json;
  orbitNamed = ../../../vendor/orbit-cli/src/orbit/data/schemes/orbit/default/dark.txt;

  yaziTheme = pkgs.runCommand "orbit-yazi-theme" {
    nativeBuildInputs = [ pkgs.python3 ];
  } ''
    python3 ${generator} ${scheme} ${orbitNamed} ${./yazi-theme.tmpl.toml} yazi > $out
  '';
in {
  home.packages = [ pkgs.yazi ];

  home.file = {
    ".config/yazi/theme.toml".source = yaziTheme;

    ".config/yazi/yazi.toml".text = ''
      [manager]
      show_hidden = false
      sort_by = "natural"
      sort_dir_first = true

      [opener]
      edit = [
        { run = "zed \"$@\"", desc = "Edit", block = true },
      ]
    '';
  };
}