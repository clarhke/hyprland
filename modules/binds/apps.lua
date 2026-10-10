-- BINDS: launching apps. https://wiki.hypr.land/Configuring/Basics/Binds/
local v = require("modules.vars")

hl.bind("SHIFT + Shift_R",  hl.dsp.exec_cmd(v.terminal))
hl.bind(v.mod .. " + E",    hl.dsp.exec_cmd(v.menu))
hl.bind(v.mod .. " + A",    hl.dsp.exec_cmd(v.fileManager))
hl.bind(v.mod .. " + S",    hl.dsp.exec_cmd(v.browser))
