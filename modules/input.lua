-- INPUT: keyboard, mouse, touchpad.
hl.config({
    input = {
        kb_layout  = "gb",    -- "us" for a US keyboard
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0.5,   -- -1.0 to 1.0, 0 = no change

        touchpad = { natural_scroll = false },
    },
})
