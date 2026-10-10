-- BAR STYLE: CSS template. {{name}} is replaced with a colour from modules/palette.lua.
-- Waybar itself still needs CSS; Lua just fills in the colours.
return {
    font_family = "sans-serif",
    font_size   = "14px",

    css = [=[
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
]=],
}
