{ myvars, pkgs, ... }:
{
  users.users.${myvars.username} = {
    isNormalUser = true;
    description = myvars.userfullname;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
    ];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = myvars.sshAuthorizedKeys or [ ];
  };

  programs.fish.enable = true;
}