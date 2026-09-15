{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Eduardo Fabisiak";
        email = "eduardofabisiak@proton.me";
      };
      safe.directory = "/etc/nixos";
    };
  };

  home.packages = with pkgs; [
    lazygit
    lazydocker
    gh
  ];

  xdg.desktopEntries = {
    lazygit = {
      name = "Lazygit";
      comment = "A simple terminal UI for git commands";
      icon = "git";
      exec = "ghostty -e lazygit";
      categories = [ "Development" ];
      terminal = false;
    };
    lazydocker = {
      name = "Lazydocker";
      comment = "The lazier way to manage everything Docker";
      icon = "docker";
      exec = "ghostty -e lazydocker";
      categories = [ "Development" ];
      terminal = false;
    };
  };
}