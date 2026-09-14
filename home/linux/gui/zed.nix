{
  inputs,
  pkgs,
  ...
}:

let
  generator = ../../../config/gen-orbit-themes.py;
  scheme = ../../../config/misc/orbit/scheme.json;
  orbitNamed = ../../../vendor/orbit-cli/src/orbit/data/schemes/orbit/default/dark.txt;
  zedTemplate = ../../../vendor/orbit-cli/src/orbit/data/templates/zed.json;

  orbitshellZed = pkgs.runCommand "orbit-zed-theme" {
    nativeBuildInputs = [ pkgs.python3 ];
  } ''
    python3 ${generator} ${scheme} ${orbitNamed} ${zedTemplate} zed > $out
  '';
in {
  home.packages = with pkgs; [ zed-editor ];

  home.file = {
    ".config/zed/themes/orbit.json".source = orbitshellZed;

    

    

    ".config/zed/settings.json".text = ''
      {
        "ui_font_size": 16,
        "buffer_font_size": 16,
        "theme": {
          "mode": "dark",
          "dark": "Orbit"
        },
        "buffer_font_family": "JetBrainsMono Nerd Font",
        "buffer_font_features": { "calt": true },
        "multi_cursor_modifier": "cmd_or_ctrl",
        "languages": {
          "Nix": {
            "language_servers": ["nixd", "!nil"]
          },
          "QML": {
            "formatter": {
              "external": {
                "command": "sh",
                "arguments": ["-c", "tmp=$(mktemp --suffix .qml); cat > $tmp; qmlformat $tmp"]
              }
            }
          }
        },
        "lsp": {
          "nixd": {
            "settings": {
              "nixpkgs": {
                "expr": "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs {}"
              },
              "formatting": { "command": ["alejandra"] }
            }
          },
          "qml": {
            "binary": { "arguments": ["-E"] }
          }
        }
      }
    '';

    

    ".config/zed/keymap.json".text = ''
      [
        {
          "context": "Editor",
          "bindings": {
            "ctrl-shift-up": "editor::MoveLineUp",
            "ctrl-shift-down": "editor::MoveLineDown",
            "alt-down": ["editor::SelectNext", { "replace_newest": false }],
            "alt-up": ["editor::SelectPrevious", { "replace_newest": false }]
          }
        }
      ]
    '';
  };
}
