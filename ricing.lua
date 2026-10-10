-- ============================================================================
-- RICING.LUA: everything about how your desktop LOOKS.
--
--   * Colours (the palette) .......... also used by waybar.lua for the bar
--   * Gaps, borders, rounding, opacity
--   * Blur and shadows
--   * Animations (curves + what moves)
--
-- Loaded by hyprland.lua with require("ricing").
-- Apply changes with:  hyprctl reload
-- If you change a COLOUR, also regenerate the bar:
--     lua ~/code/hyprland/waybar.lua && pkill waybar; waybar &
-- ============================================================================


-- ============================================================================
-- 1. COLOURS
-- Raw hex, no "#" and no alpha. Change a colour here and both Hyprland
-- (borders, shadow) and Waybar (bar background, text) pick it up.
-- ============================================================================
local palette = {
    bg        = "111318",   -- bar background
    fg        = "ffffff",   -- bar text
    highlight = "333842",   -- active workspace button
    accent1   = "bbbbbb",   -- active window border, gradient start
    accent2   = "bbbbbb",   -- active window border, gradient end
    inactive  = "222222",   -- inactive window border
    critical  = "ff5555",   -- low battery warning
    shadow    = "1a1a1a",   -- window shadow
}


-- Everything below only runs inside Hyprland. waybar.lua loads this file with
-- plain Lua (where `hl` doesn't exist) just to read the palette above.
if hl then

    -- Turns a hex colour + alpha into the format Hyprland wants, e.g. rgba(33ccffee)
    local function rgba(hex, alpha) return "rgba(" .. hex .. alpha .. ")" end


    -- ========================================================================
    -- 2. LOOK: gaps, borders, rounding, opacity, blur, shadow
    -- https://wiki.hypr.land/Configuring/Basics/Variables/
    -- ========================================================================
    hl.config({
        general = {
            gaps_in     = 5,     -- gap between windows
            gaps_out    = 20,    -- gap between windows and the screen edge
            border_size = 2,

            col = {
                -- active border is a gradient from accent1 to accent2 at 45 degrees
                active_border   = { colors = { rgba(palette.accent1, "ee"), rgba(palette.accent2, "ee") }, angle = 45 },
                inactive_border = rgba(palette.inactive, "aa"),
            },

            resize_on_border = false,        -- true = drag borders/gaps to resize
            allow_tearing    = false,        -- see the Tearing wiki page before enabling
            layout           = "dwindle",    -- "dwindle", "master" or "scrolling"
        },

        decoration = {
            rounding       = 10,
            rounding_power = 2,      -- 2 = normal circles, higher = squircle-ish corners

            active_opacity   = 1.0,  -- try 0.95 for slightly see-through windows
            inactive_opacity = 1.0,  -- try 0.85 to fade unfocused windows
            -- Ideas (uncomment and check names on the wiki):
            -- dim_inactive = true,
            -- dim_strength = 0.15,

            -- BLUR: shows through transparent windows and bars
            blur = {
                enabled  = true,
                size     = 3,        -- bigger = blurrier
                passes   = 1,        -- more passes = smoother but costs GPU
                vibrancy = 0.1696,
                -- Ideas: noise, contrast, brightness, popups = true
            },

            -- SHADOW: drop shadow behind windows
            shadow = {
                enabled      = true,
                range        = 4,
                render_power = 3,
                color        = tonumber("0xee" .. palette.shadow),
            },
        },
    })


    -- ========================================================================
    -- 3. CURVES: the "feel" of motion
    -- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
    -- A bezier curve is two control points. Preview shapes at cubic-bezier.com
    -- Curves must be defined BEFORE the animations that use them.
    -- ========================================================================
    hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
    hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
    hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}    } })
    hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
    hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}  } })

    -- A spring is physics-based: stiffness = snappiness, dampening = how fast it settles
    hl.curve("easy", { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })


    -- ========================================================================
    -- 4. ANIMATIONS: which things move and how
    -- speed is in 1/10 of a second, so a BIGGER number is SLOWER.
    -- Each line picks a curve from section 3.
    -- ========================================================================
    hl.config({ animations = { enabled = true } })   -- set to false to turn all animations off

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
    -- Try: style = "slide" or "slidevert" on the workspaces lines for sliding instead of fading

end

-- waybar.lua reads the palette from here
return { palette = palette }
