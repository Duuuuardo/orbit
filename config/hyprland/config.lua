hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
    },

    general = {
        
        gaps_in = 5,
        gaps_out = 10,
        gaps_workspaces = 20,
        border_size = 1,
        layout = "dwindle",

        
        ["col.active_border"]   = "rgba(c2c1ffe6)",
        ["col.inactive_border"] = "rgba(c8c5d111)",
    },

    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        initial_workspace_tracking = false,
    },
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_SIZE", "24")
