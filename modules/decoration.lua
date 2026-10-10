-- DECORATION: rounding and opacity. https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    decoration = {
        rounding       = 10,
        rounding_power = 2,      -- 2 = normal circles, higher = squircle-ish corners

        active_opacity   = 1.0,  -- try 0.95 for slightly see-through windows
        inactive_opacity = 1.0,  -- try 0.85 to fade unfocused windows

        -- Ideas (uncomment and check names on the wiki):
        -- dim_inactive = true,
        -- dim_strength = 0.15,
    },
})
