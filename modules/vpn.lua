-- PROTON VPN: SUPER + P hides/shows the VPN window (VPN stays connected). Needs jq.
local v = require("modules.vars")

local vpn_toggle = [==[
info=$(hyprctl clients -j | jq -r '.[] | select(.title=="Proton VPN") | "\(.address) \(.workspace.name)"' | head -n1)
if [ -z "$info" ]; then
  protonvpn-app &
  exit
fi
addr=${info% *}
ws=${info#* }
if [ "$ws" != "special:vpn" ]; then
  hyprctl dispatch "hl.dsp.window.move({ workspace = \"special:vpn\", follow = false, window = \"address:$addr\" })"
else
  hyprctl dispatch 'hl.dsp.workspace.toggle_special("vpn")'
fi
]==]

hl.bind(v.mod .. " + P", hl.dsp.exec_cmd("bash -c '" .. (vpn_toggle:gsub("'", "'\\''")) .. "'"))
