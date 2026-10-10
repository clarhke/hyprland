-- RICE: everything visual. Edit this file to change how your desktop looks.
-- Loaded by hyprland.lua, and also read by waybar.lua so the bar shares the colours.

-- COLOURS: raw hex (no # and no alpha)
local palette = {
    bg        = "111318",
    fg        = "ffffff",
    highlight = "333842",
    accent1   = "33ccff",
    accent2   = "00ff99",
    inactive  = "595959",
    critical  = "ff5555",
    shadow    = "1a1a1a",
}

-- Everything below only runs inside Hyprland (waybar.lua loads this file with plain lua,
-- where `hl` doesn't exist, just to read the palette).
if hl then
    local function rgba(hex, alpha) return "rgba(" .. hex .. alpha .. ")" end

    -- LOOK: https://wiki.hypr.land/Configuring/Basics/Variables/
    hl.config({
        general = {
            gaps_in     = 5,     -- gap between windows
            gaps_out    = 20,    -- gap between windows and screen edge
            border_size = 2,
            col = {
                active_border   = { colors = { rgba(palette.accent1, "ee"), rgba(palette.accent2, "ee") }, angle = 45 },
                inactive_border = rgba(palette.inactive, "aa"),
            },
            resize_on_border = false,
            allow_tearing    = false,
            layout           = "dwindle",   -- "dwindle", "master" or "scrolling"
        },

        decoration = {
            rounding         = 10,
            rounding_power   = 2,      -- higher = squircle-ish corners
            active_opacity   = 1.0,    -- try 0.95 for see-through windows
            inactive_opacity = 1.0,    -- try 0.85 to fade unfocused windows
            -- Ideas (check names on the wiki): dim_inactive = true, dim_strength = 0.15

            shadow = {
                enabled      = true,
                range        = 4,
                render_power = 3,
                color        = tonumber("0xee" .. palette.shadow),
            },

            blur = {
                enabled  = true,
                size     = 3,      -- bigger = blurrier
                passes   = 1,      -- more = smoother but costs GPU
                vibrancy = 0.1696,
            },
        },

        animations = { enabled = true },
    })

    -- CURVES: the feel of motion. https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
    hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
    hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
    hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}    } })
    hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
    hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })
    hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

    -- ANIMATIONS: speed is in 1/10 s, so bigger = SLOWER
    hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
    hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
    hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, spring = "easy" })
    hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  spring = "easy",         style = "popin 87%" })
    hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
    hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
    hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
    hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
    hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
    hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
    hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
    hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
    hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
    hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })
end

return { palette = palette }
