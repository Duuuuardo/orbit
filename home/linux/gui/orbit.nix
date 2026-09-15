{ inputs, lib, pkgs, ... }:

{
  imports = [
    inputs.orbit-shell.homeManagerModules.default
  ];

  

  home.packages = with pkgs; [
    pavucontrol
    pwvucontrol
    swappy
    cliphist
    wl-clipboard
    hyprpicker
    fuzzel
  ];

  programs.orbit = {
    enable = true;

    

    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };

    settings = {
      

      appearance = {
        transparency.enabled = false;

        

        

        rounding.scale = 1.0;
        spacing.scale = 1.0;
        padding.scale = 0.7;
        font.scale = 1.1;
      };

      

      

      border.thickness = 0;
      border.rounding = 0;

      

      

      bar.activeWindow.showOnHover = false;

      

      

      bar.workspaces = {
        displayType = "text";
        showWindows = true;
        maxWindowIcons = 5;
        label = "";
        occupiedLabel = "";
        activeLabel = "";
      };

      

      dashboard.showOnHover = false;

      background = {
        enabled = true;
        

        

        wallpaperEnabled = false;
        desktopClock.enabled = false;
        visualiser.enabled = false;
      };

      lock = {
        enabled = true;

        

        

        useWallpaper = true;
        wallpaperVideo = "/etc/backgrounds/gravitys-edge.mp4";
        recolourLogo = true;
        enableFprint = false;
        enableHowdy = false;
        hideNotifs = false;
      };

      launcher = {
        enableDangerousActions = false;
        

        actions = [
          {
            name = "Calculator";
            icon = "calculate";
            description = "Do simple math equations (powered by Qalc)";
            command = [ "autocomplete" "calc" ];
            enabled = true;
            dangerous = false;
          }
          {
            name = "Shutdown";
            icon = "power_settings_new";
            description = "Shutdown the system";
            command = [ "poweroff" ];
            enabled = true;
            dangerous = true;
          }
          {
            name = "Reboot";
            icon = "cached";
            description = "Reboot the system";
            command = [ "reboot" ];
            enabled = true;
            dangerous = true;
          }
          {
            name = "Logout";
            icon = "exit_to_app";
            description = "Log out of the current session";
            command = [ "logout" ];
            enabled = true;
            dangerous = true;
          }
          {
            name = "Lock";
            icon = "lock";
            description = "Lock the current session";
            command = [ "loginctl" "lock-session" ];
            enabled = true;
            dangerous = false;
          }
          {
            name = "Sleep";
            icon = "bedtime";
            description = "Suspend then hibernate";
            command = [ "suspendThenHibernate" ];
            enabled = true;
            dangerous = false;
          }
        ];
      };

      services = {
        

        smartScheme = false;
        useTwelveHourClock = false;

        

        weatherUnits = "celsius";
        sensorUnits = "celsius";
      };

      

      utilities.toasts = {
        capsLockChanged = false;
        numLockChanged = false;
      };

      general.apps = {
        terminal = [ "ghostty" "-e" ];
        audio = [ "pwvucontrol" ];
        playback = [ "mpv" ];
        explorer = [ "ghostty" "-e" ];
      };

      paths.wallpaperDir = "~/Pictures/Wallpapers";
    };

    cli.enable = true;
  };

  

  home.file = {
    ".local/state/orbit/scheme.json".source =
      ../../../config/misc/orbit/scheme.json;
    ".local/state/orbit/wallpaper/path.txt".text =
      "/etc/backgrounds/gravitys-edge.png";

    

    

    ".config/orbit/shell-tokens.json".text = builtins.toJSON {
      sizes.bar.innerWidth = 34;
    };
  };
}
