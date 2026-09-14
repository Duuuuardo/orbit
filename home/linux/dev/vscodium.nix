{ pkgs, ... }:
{
  home.packages = [ pkgs.vscodium ];

  home.file.".config/VSCodium/User/settings.json".text = builtins.toJSON {
    "workbench.colorTheme" = "Default Dark Modern";
    "editor.fontFamily" = "JetBrainsMono Nerd Font";
    "editor.fontLigatures" = true;
    "editor.fontSize" = 13;
    "editor.renderWhitespace" = "none";
    "editor.minimap.enabled" = false;
    "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
    "git.autofetch" = true;
    "files.autoSave" = "afterDelay";
  };
}