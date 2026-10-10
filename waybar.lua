-- WAYBAR GENERATOR: writes ~/.config/waybar/config.jsonc and style.css, using the colours in rice.lua.
-- Run:  lua ~/code/hyprland/waybar.lua && pkill waybar; waybar &
local dir = arg[0]:match("(.*/)") or "./"
package.path = dir .. "?.lua;" .. package.path
local palette = require("rice").palette

----------------------------------------------------------------
-- BAR LAYOUT: what Waybar shows. Edit modules here.
----------------------------------------------------------------
local bar = {
    layer    = "top",
    position = "top",
    height   = 32,

    ["modules-left"]   = { "hyprland/workspaces" },
    ["modules-center"] = { "clock" },
    ["modules-right"]  = { "cpu", "memory", "network", "pulseaudio", "backlight", "battery" },

    ["hyprland/workspaces"] = { format = "{name}", ["on-click"] = "activate" },

    clock = { format = "{:%a %d %b   %H:%M}", ["tooltip-format"] = "{:%A, %d %B %Y}" },
    cpu    = { format = "CPU {usage}%" },
    memory = { format = "RAM {percentage}%" },

    network = {
        ["format-wifi"]         = "WiFi {signalStrength}%",
        ["format-ethernet"]     = "Ethernet",
        ["format-disconnected"] = "Offline",
    },

    pulseaudio = { format = "VOL {volume}%", ["format-muted"] = "MUTED" },
    backlight  = { format = "☀ {percent}%" },

    battery = {
        states              = { critical = 10 },
        format              = "BAT {capacity}%",
        ["format-charging"] = "BAT {capacity}% ⚡",
        ["format-full"]     = "BAT {capacity}%",
        ["format-critical"] = "LOW BAT {capacity}%",
    },
}

----------------------------------------------------------------
-- BAR STYLE: CSS template. {{name}} is filled from the palette in rice.lua.
-- Waybar still needs CSS; Lua just supplies the colours.
----------------------------------------------------------------
local font = { font_family = "sans-serif", font_size = "14px" }

local css_template = [=[
* {
    font-family: {{font_family}};
    font-size: {{font_size}};
}

window#waybar {
    background: #{{bg}};
    color: #{{fg}};
}

#workspaces button {
    color: #{{fg}};
    padding: 0 8px;
}

#workspaces button.active {
    background: #{{highlight}};
}

#clock,
#cpu,
#memory,
#network,
#pulseaudio,
#backlight,
#battery {
    padding: 0 10px;
}

#battery.critical:not(.charging) {
    color: #{{critical}};
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: steps(12);
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

@keyframes blink {
    to {
        background-color: #{{critical}};
        color: #{{bg}};
    }
}
]=]

----------------------------------------------------------------
-- BUILD (you shouldn't need to edit below this line)
----------------------------------------------------------------
local function esc(s)
    return (s:gsub('[%c"\\]', function(c)
        local map = { ['"'] = '\\"', ['\\'] = '\\\\', ['\n'] = '\\n', ['\t'] = '\\t' }
        return map[c] or string.format("\\u%04x", c:byte())
    end))
end

local function encode(v, indent)
    indent = indent or ""
    local t = type(v)
    if t == "string" then return '"' .. esc(v) .. '"' end
    if t == "number" or t == "boolean" then return tostring(v) end
    local inner = indent .. "    "
    if #v > 0 then
        local parts = {}
        for _, x in ipairs(v) do parts[#parts + 1] = inner .. encode(x, inner) end
        return "[\n" .. table.concat(parts, ",\n") .. "\n" .. indent .. "]"
    end
    local keys = {}
    for k in pairs(v) do keys[#keys + 1] = k end
    table.sort(keys)
    local parts = {}
    for _, k in ipairs(keys) do
        parts[#parts + 1] = inner .. '"' .. esc(k) .. '": ' .. encode(v[k], inner)
    end
    return "{\n" .. table.concat(parts, ",\n") .. "\n" .. indent .. "}"
end

local values = {}
for k, v in pairs(palette) do values[k] = v end
for k, v in pairs(font) do values[k] = v end

local css = css_template:gsub("{{([%w_]+)}}", function(k)
    return values[k] or error("unknown name in css template: " .. k)
end)

local out = os.getenv("HOME") .. "/.config/waybar/"
local function write(name, text)
    local f = assert(io.open(out .. name, "w"))
    f:write(text, "\n")
    f:close()
    print("wrote " .. out .. name)
end

write("config.jsonc", encode(bar))
write("style.css", css)
