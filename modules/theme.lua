-- THEME: turns palette hex values into the formats Hyprland wants.
local p = require("modules.palette")

local function rgba(hex, alpha) return "rgba(" .. hex .. alpha .. ")" end

return {
    rgba = rgba,
    border_active   = { colors = { rgba(p.accent1, "ee"), rgba(p.accent2, "ee") }, angle = 45 },
    border_inactive = rgba(p.inactive, "aa"),
    shadow          = tonumber("0xee" .. p.shadow),
}
