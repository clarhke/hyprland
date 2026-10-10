-- BAR LAYOUT: what Waybar shows. Becomes ~/.config/waybar/config.jsonc
-- Edit modules here, then run:  lua ~/code/hyprland/waybar/build.lua
return {
    layer    = "top",
    position = "top",
    height   = 32,

    ["modules-left"]   = { "hyprland/workspaces" },
    ["modules-center"] = { "clock" },
    ["modules-right"]  = { "cpu", "memory", "network", "pulseaudio", "backlight", "battery" },

    ["hyprland/workspaces"] = { format = "{name}", ["on-click"] = "activate" },

    clock = {
        format = "{:%a %d %b   %H:%M}",
        ["tooltip-format"] = "{:%A, %d %B %Y}",
    },

    cpu    = { format = "CPU {usage}%" },
    memory = { format = "RAM {percentage}%" },

    network = {
        ["format-wifi"]         = "WiFi {signalStrength}%",
        ["format-ethernet"]     = "Ethernet",
        ["format-disconnected"] = "Offline",
    },

    pulseaudio = { format = "VOL {volume}%", ["format-muted"] = "MUTED" },

    backlight = { format = "☀ {percent}%" },

    battery = {
        states             = { critical = 10 },
        format             = "BAT {capacity}%",
        ["format-charging"] = "BAT {capacity}% ⚡",
        ["format-full"]     = "BAT {capacity}%",
        ["format-critical"] = "LOW BAT {capacity}%",
    },
}
