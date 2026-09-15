{ inputs, pkgs, ... }:
let
  astra-airlock = inputs.astra-airlock.packages.${pkgs.stdenv.hostPlatform.system}.default;

  greetdHyprlandLua = pkgs.writeText "greetd-hyprland.lua" ''
    hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

    hl.config({
      animations = { enabled = false },
      decoration = {
        blur = { enabled = false },
        shadow = { enabled = false },
      },
      input = {
        kb_layout = "us-pt",
        numlock_by_default = false,
        repeat_delay = 250,
        repeat_rate = 35,
        touchpad = {
          natural_scroll = true,
          disable_while_typing = true,
          scroll_factor = 0.3,
        },
      },
      misc = {
        disable_autoreload = true,
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
      },
    })

    local cursor_theme = "Bibata-Modern-Classic"
    local cursor_size = "24"
    hl.env("HYPRCURSOR_THEME", cursor_theme)
    hl.env("HYPRCURSOR_SIZE", cursor_size)
    hl.env("XCURSOR_THEME", cursor_theme)
    hl.env("XCURSOR_SIZE", cursor_size)

    hl.on("hyprland.start", function()
      hl.exec_cmd("echo HOOK-FIRED >> /tmp/greetd-hook.log; "
        .. "${astra-airlock}/bin/astra-airlock > /tmp/airlock.log 2>&1; "
        .. "echo HOOK-EXIT=$? >> /tmp/greetd-hook.log; "
        .. "${pkgs.hyprland}/bin/hyprctl dispatch exit")
    end)
  '';
in
{
  services.greetd = {
    enable = true;

    settings.default_session = {
      command = "${pkgs.hyprland}/bin/start-hyprland -- -c ${greetdHyprlandLua} >/tmp/hypr-kiosk.log 2>&1";
      user = "greeter";
    };
  };

  users.users.greeter = {
    extraGroups = [ "video" "render" ];
  };

  environment.systemPackages = [
    astra-airlock
    pkgs.mpvpaper
  ];

  systemd.tmpfiles.rules = [
    "d /var/cache/astra-airlock 0755 greeter greeter -"
  ];
}