hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + B", hl.dsp.exec_cmd("zen-twilight"))

hl.bind("SUPER + SPACE", hl.dsp.global("orbit:launcher"))
hl.bind("SUPER + L", hl.dsp.global("orbit:lock"))
hl.bind("SUPER + V", hl.dsp.global("orbit:clipboard"))

hl.bind("SUPER + N", hl.dsp.global("orbit:sidebar"))
hl.bind("SUPER + O", hl.dsp.global("orbit:showall"))
hl.bind("CTRL + ALT + Delete", hl.dsp.global("orbit:session"))
hl.bind("CTRL + ALT + C", hl.dsp.global("orbit:clearNotifs"))

hl.bind("SUPER + Q", hl.dsp.window.close())

hl.bind(
    "SUPER + F",
    hl.dsp.window.fullscreen({
        mode = "fullscreen",
        action = "toggle",
    })
)

hl.bind(
    "SUPER + SHIFT + F",
    hl.dsp.window.float({
        action = "toggle",
    })
)

hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }))
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }))

hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "r" }))

hl.bind("SUPER + LEFT", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + RIGHT", hl.dsp.focus({ direction = "r" }))
hl.bind("SUPER + UP", hl.dsp.focus({ direction = "u" }))
hl.bind("SUPER + DOWN", hl.dsp.focus({ direction = "d" }))

hl.bind("SUPER + SHIFT + LEFT", hl.dsp.window.move({ direction = "l" }))
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.move({ direction = "r" }))
hl.bind("SUPER + SHIFT + UP", hl.dsp.window.move({ direction = "u" }))
hl.bind("SUPER + SHIFT + DOWN", hl.dsp.window.move({ direction = "d" }))

for i = 1, 7 do
    hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 10%+"),
    { locked = true, repeating = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"),
    { locked = true, repeating = true }
)

hl.bind("XF86MonBrightnessUp", hl.dsp.global("orbit:brightnessUp"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.global("orbit:brightnessDown"), { locked = true })

hl.bind("XF86AudioPlay", hl.dsp.global("orbit:mediaToggle"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.global("orbit:mediaToggle"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.global("orbit:mediaNext"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.global("orbit:mediaPrev"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.global("orbit:mediaStop"), { locked = true })

hl.bind("Print", hl.dsp.exec_cmd("orbit screenshot"), { locked = true })
hl.bind("SUPER + SHIFT + S", hl.dsp.global("orbit:screenshotFreeze"), { locked = true })
hl.bind("SUPER + SHIFT + ALT + S", hl.dsp.global("orbit:screenshot"), { locked = true })