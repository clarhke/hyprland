-- Generates ~/.config/waybar/config.jsonc and style.css from bar.lua, style.lua and palette.lua
-- Run:  lua ~/code/hyprland/waybar/build.lua && pkill waybar; waybar &
local dir = arg[0]:match("(.*/)") or "./"
package.path = dir .. "?.lua;" .. dir .. "../modules/?.lua;" .. package.path

local json    = require("json")
local palette = require("palette")
local bar     = require("bar")
local style   = require("style")

local out = os.getenv("HOME") .. "/.config/waybar/"

local function write(name, text)
    local f = assert(io.open(out .. name, "w"))
    f:write(text, "\n")
    f:close()
    print("wrote " .. out .. name)
end

local values = {}
for k, v in pairs(palette) do values[k] = v end
values.font_family = style.font_family
values.font_size   = style.font_size

local css = style.css:gsub("{{([%w_]+)}}", function(k)
    return values[k] or error("unknown colour/setting in style.lua: " .. k)
end)

write("config.jsonc", json.encode(bar))
write("style.css", css)
