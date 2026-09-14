{ ... }:
{
  programs.fish = {
    enable = true;

    functions = {
      fish_greeting = {
        body = ''
          command -v fastfetch > /dev/null && fastfetch --key-padding-left 5
        '';
      };
    };

    shellAbbrs = {
      lg = "lazygit";
      ld = "lazydocker";
      gd = "git diff";
      ga = "git add .";
      gc = "git commit -am";
      gl = "git log";
      gs = "git status";
      gst = "git stash";
      gsp = "git stash pop";
      gp = "git push";
      gpl = "git pull";
      gsw = "git switch";
      gsm = "git switch main";
      gb = "git branch";
      gbd = "git branch -d";
      gco = "git checkout";
      gsh = "git show";
    };

    interactiveShellInit = ''
      if command -v starship > /dev/null
        starship init fish | source
      end

      if command -v zoxide > /dev/null
        zoxide init fish --cmd cd | source
      end

      if command -v direnv > /dev/null
        direnv hook fish | source
      end

      cat ~/.local/state/orbit/sequences.txt 2> /dev/null

      function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
      end
    '';
  };

  home.file.".config/starship.toml".source = ../../../config/misc/starship.toml;
}