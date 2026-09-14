hl.config({
    gestures = {
        workspace_swipe_distance                 = 700,
        workspace_swipe_cancel_ratio             = 0.15,
        workspace_swipe_min_speed_to_force       = 5,
        workspace_swipe_direction_lock           = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_create_new               = true,
    },
})

-- 4 finger horizontal swipe to switch workspaces
hl.gesture({ fingers = vars.workspaceSwipeFingers, direction = "horizontal", action = "workspace" })

-- 3 finger swipe up to open the special workspace
hl.gesture({ fingers = vars.gestureFingers, direction = "up", action = "special", workspace_name = "special" })
-- 3 finger swipe down to toggle the special workspace
hl.gesture({
    fingers   = vars.gestureFingers,
    direction = "down",
    action    = function()
        hl.exec_cmd("orbit toggle specialws")
    end,
})
-- 4 finger swipe down to sleep
hl.gesture({
    fingers   = vars.gestureFingersMore,
    direction = "down",
    action    = function()
        hl.exec_cmd(vars.sleepGestureCmd)
    end,
})