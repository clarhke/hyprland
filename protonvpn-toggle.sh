#!/bin/bash
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
