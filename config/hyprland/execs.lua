hl.on("hyprland.start", function()
    -- Environment
    hl.exec_cmd("dbus-update-activation-environment --systemd XCURSOR_THEME XCURSOR_SIZE HYPRCURSOR_THEME HYPRCURSOR_SIZE")

    -- Clipboard history
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Cursors
    hl.exec_cmd("hyprctl setcursor " .. vars.cursorTheme .. " " .. vars.cursorSize)
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme " .. vars.cursorTheme)
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size " .. vars.cursorSize)

    -- Wallpaper
    hl.exec_cmd("mpvpaper -vs -o 'no-audio loop hwdec=auto' '*' /etc/backgrounds/gravitys-edge.mp4")

    -- Start shell
    hl.exec_cmd("orbit shell -d")

    -- Watchdog: keep exactly one orbit-shell instance running
    hl.exec_cmd("while hyprctl activewindow >/dev/null 2>&1; do n=$(pgrep -cf '[o]rbit-shell-1.0.0/share/orbit-shell'); if [ \"$n\" -gt 1 ]; then pkill -f quickshell; sleep 2; elif [ \"$n\" = 0 ]; then orbit shell -d; sleep 6; fi; sleep 3; done")

    -- Keep the theme in sync for zen (browser)
    hl.exec_cmd("while true; do zen-apply-theme; sleep 10; done")
end)

-- Resizer listeners
local function apply_resizer_rules(win)
    local float_center = {
        hl.dsp.window.float({ action = "on", window = win }),
        hl.dsp.window.center({ window = win }),
    }
    local pip_actions = move_actions(win) or {}

    -- Bitwarden
    resizer(win, "Bitwarden", 20, 54, float_center, true, "class")                                                                 -- Native app
    resizer(win, "^Extension: %(Bitwarden Password Manager%) %- Bitwarden", 20, 54, float_center, false)                           -- Firefox
    resizer(win, "nngceckbapebfimnlniiiahkandclblb", 20, 54, float_center, true, "class")                                          -- Chromium

    -- Picture in picture
    resizer(win, "Picture[- ]in[- ][Pp]icture", 0, 0, pip_actions, false)
end

hl.on("window.title", apply_resizer_rules)
hl.on("window.open", apply_resizer_rules)