{ pkgs, ... }:
{
  home.packages = [ pkgs.vscodium ];

  home.file.".config/VSCodium/User/settings.json".text = builtins.toJSON {
    "workbench.colorTheme" = "Default Dark Modern";
    "editor.fontFamily" = "CaskaydiaCove Nerd Font";
    "editor.fontLigatures" = true;
    "editor.fontSize" = 13;
    "editor.renderWhitespace" = "none";
    "editor.minimap.enabled" = false;
    "terminal.integrated.fontFamily" = "CaskaydiaCove Nerd Font";
    "git.autofetch" = true;
    "files.autoSave" = "afterDelay";
  };
}