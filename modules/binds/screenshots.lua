-- BINDS: screenshots.
local v = require("modules.vars")

hl.bind("PRINT",                hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(v.mod .. " + PRINT",    hl.dsp.exec_cmd("hyprshot -m region -o $HOME/misc"))
