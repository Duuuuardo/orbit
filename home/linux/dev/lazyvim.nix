{
  pkgs,
  ...
}:

let
  lazyvim-starter = pkgs.fetchFromGitHub {
    owner = "LazyVim";
    repo = "starter";
    rev = "803bc181d7c0d6d5eeba9274d9be49b287294d99";
    sha256 = "0lr0ijn3xrbg4qsva3ma5zjanxjb7qa0dsn31gw5bbzq62a6gfj2";
  };

  nvim-config = ./nvim;

  lazyvim-config = pkgs.runCommand "lazyvim-config" { } ''
    cp -a ${lazyvim-starter}/. "$out"
    chmod -R u+w "$out"
    rm -rf "$out/lua/config" "$out/lua/plugins" "$out/init.lua"
    cp -a ${nvim-config}/. "$out/"
  '';
in {
  home.packages = [
    (pkgs.neovim.override {
      extraMakeWrapperArgs =
        "--prefix PATH : ${pkgs.lib.makeBinPath [
          pkgs.git
          pkgs.ripgrep
          pkgs.fd
          pkgs.python3
          pkgs.nodejs
          pkgs.fish
          pkgs.gcc
          pkgs.gnumake
          pkgs.pkg-config
        ]}";
    })
  ];

  home.file.".config/nvim".source = lazyvim-config;
}