{
  pkgs,
  ...
}:

let
  generator = ./gen-orbit-themes.py;
  scheme = ../../../assets/orbit/scheme.json;
  orbitNamed = ../../../vendor/orbit-cli/src/orbit/data/schemes/orbit/default/dark.txt;
  zenTemplate = ./zen-userchrome.tmpl.css;

  zenUserChrome = pkgs.runCommand "orbit-zen-theme" {
    nativeBuildInputs = [ pkgs.python3 ];
  } ''
    python3 ${generator} ${scheme} ${orbitNamed} ${zenTemplate} zen > $out
  '';

  zenUserJs = ''
    user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
    user_pref("ui.systemUsesDarkTheme", 1);
    user_pref("zen.theme.color-scheme", "dark");
  '';

  zenUserJsFile = pkgs.writeText "zen-user.js" zenUserJs;

  applyTheme = pkgs.writeShellScriptBin "zen-apply-theme" ''
    base="''${ZEN_PROFILE_DIR:-}"
    if [[ -z "$base" ]]; then
      for candidate in "$HOME/.config/zen" "$HOME/.zen"; do
        if [[ -f "$candidate/profiles.ini" ]]; then
          base="$candidate"
          break
        fi
      done
    fi
    [[ -z "$base" ]] && base="$HOME/.config/zen"
    profile=""

    if [[ -f "$base/profiles.ini" ]]; then
      candidate="$(sed -n 's/^Path=//p' "$base/profiles.ini" | head -n1)"
      if [[ -n "$candidate" ]]; then
        case "$candidate" in
          /*) profile="$candidate" ;;
          *) profile="$base/$candidate" ;;
        esac
      fi
    fi

    if [[ -z "$profile" || ! -f "$profile/prefs.js" ]]; then
      prefs="$(find "$base" -maxdepth 2 -name prefs.js 2>/dev/null | head -n1)"
      [[ -n "$prefs" ]] && profile="$(dirname "$prefs")"
    fi

    if [[ -n "$profile" && -d "$profile" ]]; then
      mkdir -p "$profile/chrome"
      cp -f ${zenUserChrome} "$profile/chrome/userChrome.css"
      cp -f ${zenUserJsFile} "$profile/user.js"
    fi
  '';
in {
  home.packages = [ applyTheme ];

  home.file = {
    ".config/zen/userChrome.css".source = zenUserChrome;
    ".config/zen/user.js".text = zenUserJs;
  };
}