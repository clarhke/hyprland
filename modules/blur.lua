-- BLUR: shows through transparent windows and bars.
hl.config({
    decoration = {
        blur = {
            enabled  = true,
            size     = 3,        -- bigger = blurrier
            passes   = 1,        -- more passes = smoother but costs GPU
            vibrancy = 0.1696,
            -- Ideas: noise, contrast, brightness, popups = true
        },
    },
})
