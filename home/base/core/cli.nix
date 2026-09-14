{ ... }:
{
  programs.fish.shellAliases = {
    ls = "eza --icons --group-directories-first";
    ll = "eza -l --icons --group-directories-first";
    la = "eza -a --icons --group-directories-first";
    lla = "eza -la --icons --group-directories-first";
    cat = "bat --paging=never";
    grep = "rg";
    find = "fd";
    du = "dust";
    df = "duf";
    ps = "procs";
    ping = "gping";
    rm = "trash";
    man = "tldr";
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  home.sessionVariables = {
    MANPAGER = "bat --paging=never";
  };
}