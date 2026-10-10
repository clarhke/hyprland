-- BINDS: window control and focus.
local v = require("modules.vars")
local m = v.mod

hl.bind(m .. " + W", hl.dsp.window.close())
hl.bind(m .. " + Q", hl.dsp.window.fullscreen_state({ internal = 2, client = 0, action = "toggle" }))
hl.bind(m .. " + X", hl.dsp.window.pseudo())

-- Move focus with arrow keys
hl.bind(m .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(m .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(m .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(m .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Move / resize with the mouse
hl.bind(m .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(m .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
