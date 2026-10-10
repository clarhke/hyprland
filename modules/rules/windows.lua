-- WINDOW RULES: https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- Ideas: per-app opacity, size, float, workspace, e.g.
-- hl.window_rule({ name = "kitty-fade", match = { class = "kitty" }, opacity = "0.9 0.8" })

hl.window_rule({
    -- Ignore maximize requests from apps
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class = "^$", title = "^$",
        xwayland = true, float = true, fullscreen = false, pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    -- hyprland-run windows float at the bottom left
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})
