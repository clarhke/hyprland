-- BINDS: workspaces.
local v = require("modules.vars")
local m = v.mod

-- SUPER + 1..0 switches, SUPER + SHIFT + 1..0 moves the window there
for i = 1, 10 do
    local key = i % 10   -- workspace 10 uses key 0
    hl.bind(m .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(m .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad (special workspace)
hl.bind(m .. " + D", hl.dsp.workspace.toggle_special("magic"))

-- Scroll through workspaces
hl.bind(m .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(m .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
