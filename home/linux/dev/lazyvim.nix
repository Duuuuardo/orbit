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

  nvim-config = ../../../config/nvim;

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

          pkgs.lua-language-server
          pkgs.typescript-language-server
          pkgs.vscode-langservers-extracted
          pkgs.yaml-language-server
          pkgs.tailwindcss-language-server
          pkgs.clang
          pkgs.omnisharp-roslyn
          pkgs.phpactor
          pkgs.rust-analyzer
          pkgs.netcoredbg
          pkgs.nixd

          pkgs.stylua
          pkgs.selene
          pkgs.lua54Packages.luacheck
          pkgs.shellcheck
          pkgs.shfmt
          pkgs.prettierd
          pkgs.eslint_d
          pkgs.prettier
          pkgs.php84Packages.php-cs-fixer
          pkgs.csharpier
          pkgs.fantomas

          pkgs.tree-sitter
          pkgs.alejandra
        ]}";
    })
  ];

  home.file.".config/nvim".source = lazyvim-config;
}