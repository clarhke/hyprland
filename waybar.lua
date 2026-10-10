-- ============================================================================
-- WAYBAR.LUA: generates your Waybar config and style from one file.
--
--   * BAR LAYOUT ... which modules appear and how they read
--   * BAR STYLE .... fonts and CSS (colours come from the palette in ricing.lua)
--
-- Waybar itself only understands config.jsonc and style.css, so this script
-- WRITES those two files into ~/.config/waybar/. Edit here, never in there.
--
-- Run after any change (needs the `lua` package: sudo pacman -S --needed lua):
--     lua ~/code/hyprland/waybar.lua && pkill waybar; waybar &
-- ============================================================================

local dir = arg[0]:match("(.*/)") or "./"
package.path = dir .. "?.lua;" .. package.path
local palette = require("ricing").palette   -- colours are shared with Hyprland


-- ============================================================================
-- 1. BAR LAYOUT: what Waybar shows. Becomes ~/.config/waybar/config.jsonc
-- ============================================================================
local bar = {
    layer    = "top",
    position = "top",
    height   = 32,

    -- Which modules sit where on the bar
    ["modules-left"]   = { "hyprland/workspaces" },
    ["modules-center"] = { "clock" },
    ["modules-right"]  = { "cpu", "memory", "network", "pulseaudio", "backlight", "battery" },

    -- How each module reads
    ["hyprland/workspaces"] = { format = "{name}", ["on-click"] = "activate" },

    clock = {
        format = "{:%a %d %b   %H:%M}",              -- e.g. Sun 04 Oct   14:30
        ["tooltip-format"] = "{:%A, %d %B %Y}",      -- shown when you hover
    },

    cpu    = { format = "CPU {usage}%" },
    memory = { format = "RAM {percentage}%" },

    network = {
        ["format-wifi"]         = "WiFi {signalStrength}%",
        ["format-ethernet"]     = "Ethernet",
        ["format-disconnected"] = "Offline",
    },

    -- Volume: icon only (hover for the percentage). Add " {volume}%" after {icon} to show it.
    pulseaudio = {
        format           = "{icon}",
        ["format-muted"] = "🔇",
        ["format-icons"] = { default = { "🔈", "🔉", "🔊" } },
        ["tooltip-format"] = "{volume}%",
    },

    backlight = { format = "☀ {percent}%" },

    battery = {
        states              = { critical = 10 },     -- "critical" kicks in at 10%
        -- The bar icon shrinks as the battery drains: ▁ (empty) up to █ (full)
        ["format-icons"]    = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
        format              = "{icon} {capacity}%",
        ["format-charging"] = "{icon} {capacity}% ⚡",
        ["format-full"]     = "{icon} {capacity}%",
        ["format-critical"] = "{icon} {capacity}% LOW",
    },
}


-- ============================================================================
-- 2. BAR STYLE: becomes ~/.config/waybar/style.css
-- {{name}} is replaced with a colour from the palette in ricing.lua
-- (or with font_family / font_size below).
-- ============================================================================
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


-- ============================================================================
-- 3. BUILD: you shouldn't need to edit anything below this line
-- ============================================================================

-- Tiny JSON writer, so no extra libraries are needed
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
    if #v > 0 then   -- array
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

-- Fill the {{names}} in the CSS template
local values = {}
for k, v in pairs(palette) do values[k] = v end
for k, v in pairs(font) do values[k] = v end

local css = css_template:gsub("{{([%w_]+)}}", function(k)
    return values[k] or error("unknown name in css template: " .. k)
end)

-- Write the two files Waybar reads
local out = os.getenv("HOME") .. "/.config/waybar/"
local function write(name, text)
    local f = assert(io.open(out .. name, "w"))
    f:write(text, "\n")
    f:close()
    print("wrote " .. out .. name)
end

write("config.jsonc", encode(bar))
write("style.css", css)
