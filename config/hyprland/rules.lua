

hl.window_rule({ match = { float = true }, center = true })

hl.window_rule({ match = { class = "pavucontrol|pwvucontrol" }, float = true })
hl.window_rule({ match = { class = "blueman-manager" }, float = true })
hl.window_rule({ match = { class = "nm-connection-editor" }, float = true })
hl.window_rule({ match = { class = "file-roller|org.gnome.FileRoller" }, float = true })

hl.window_rule({ match = { title = "(Select|Open|Save)( a)? (File|Folder)(s)?" }, float = true })

hl.window_rule({
    match = { title = "Picture(-| )in(-| )[Pp]icture" },
    pin = true,
    float = true,
    keep_aspect_ratio = true,
})
