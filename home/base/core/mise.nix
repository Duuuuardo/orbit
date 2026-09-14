{
  pkgs,
  lib,
  ...
}:
{
  home.file.".config/mise/config.toml".text = ''
    [tools]
    java = "latest"
    node = "latest"
    bun = "latest"
    rust = "latest"
    php = "latest"
    kotlin = "latest"
    python = "latest"
    clang = "latest"
  '';

  home.activation.installMiseTools = lib.mkAfter ''
    if [[ ! -f "$HOME/.mise-tools-installed" ]]; then
      ${pkgs.mise}/bin/mise install || true
      touch "$HOME/.mise-tools-installed"
    fi
  '';
}