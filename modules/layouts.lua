-- LAYOUTS: how windows tile.
-- https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
-- https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
hl.config({
    dwindle   = { preserve_split = true },
    master    = { new_status = "master" },
    scrolling = { fullscreen_on_one_column = true },
})
-- Hyprland 0.55 also has a Layout API for writing your own layout in Lua (see the wiki).
