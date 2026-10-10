-- SHADOW: drop shadows behind windows.
local theme = require("modules.theme")

hl.config({
    decoration = {
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = theme.shadow,   -- from palette.lua
        },
    },
})
