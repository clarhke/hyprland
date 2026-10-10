-- AUTOSTART: https://wiki.hypr.land/Configuring/Basics/Autostart/
-- Runs once on login (hyprctl reload does NOT re-run this).
hl.on("hyprland.start", function ()
    hl.exec_cmd("waybar")
    hl.exec_cmd([[bash -c 'printf "wallpaper {\n    monitor = eDP-1\n    path = %s/misc/wallpaper.png\n    fit_mode = cover\n}\n\nsplash = false\n" "$HOME" > /tmp/hyprpaper.conf && hyprpaper -c /tmp/hyprpaper.conf']])
    hl.exec_cmd("protonvpn-app")
end)
