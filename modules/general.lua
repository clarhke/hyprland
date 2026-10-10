-- GENERAL: gaps, borders, layout. https://wiki.hypr.land/Configuring/Basics/Variables/
local theme = require("modules.theme")

hl.config({
    general = {
        gaps_in     = 5,    -- gap between windows
        gaps_out    = 20,   -- gap between windows and screen edge
        border_size = 2,

        col = {
            active_border   = theme.border_active,    -- gradient from theme.lua
            inactive_border = theme.border_inactive,
        },

        resize_on_border = false,   -- true = drag borders/gaps to resize
        allow_tearing    = false,   -- see the Tearing wiki page before enabling
        layout           = "dwindle",  -- "dwindle", "master" or "scrolling"
    },
})
