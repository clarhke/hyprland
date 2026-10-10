-- Entry point. Each part of the config lives in modules/.
-- Order matters a little: curves before animations, vars before binds.

-- setup
require("modules.monitors")
require("modules.env")
require("modules.permissions")
require("modules.autostart")

-- look and feel
require("modules.general")
require("modules.decoration")
require("modules.blur")
require("modules.shadow")
require("modules.curves")
require("modules.animations")
require("modules.layouts")
require("modules.misc")

-- input
require("modules.input")
require("modules.devices")

-- binds
require("modules.binds.apps")
require("modules.binds.screenshots")
require("modules.binds.windows")
require("modules.binds.workspaces")
require("modules.binds.media")
require("modules.vpn")

-- rules
require("modules.rules.windows")
require("modules.rules.workspaces")
require("modules.rules.layers")
