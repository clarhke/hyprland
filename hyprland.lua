-- ============================================================================
-- HYPRLAND.LUA: how your desktop BEHAVES. (How it looks is in ricing.lua.)
--
--   1.  Programs ........ which terminal, browser, etc. the keys open
--   2.  Monitors
--   3.  Environment variables
--   4.  Permissions
--   5.  Autostart ....... what launches at login
--   6.  Input ........... keyboard, mouse, touchpad
--   7.  Layouts ......... how windows tile
--   8.  Misc
--   9.  Keybinds
--   10. Proton VPN toggle (SUPER + P)
--   11. Rules ........... per-window and per-workspace tweaks
--
-- Apply changes with:  hyprctl reload
-- (Autostart only runs at login, so log out and back in to test it.)
-- Wiki: https://wiki.hypr.land/Configuring/
-- ============================================================================

-- The look (colours, borders, blur, shadows, animations) lives in ricing.lua
require("ricing")


-- ============================================================================
-- 1. PROGRAMS: change a program here and every key below uses it
-- ============================================================================
local mod         = "SUPER"          -- the "Windows" key
local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "hyprlauncher"   -- app launcher
local browser     = "brave"


-- ============================================================================
-- 2. MONITORS: https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Ideas: mode = "1920x1080@60", scale = 1.5, position = "0x0"
-- ============================================================================
hl.monitor({
    output   = "",           -- empty = applies to every monitor
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


-- ============================================================================
-- 3. ENVIRONMENT VARIABLES
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
-- ============================================================================
hl.env("XCURSOR_SIZE", "15")
hl.env("HYPRCURSOR_SIZE", "15")
-- hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")   -- example: cursor theme


-- ============================================================================
-- 4. PERMISSIONS
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Changes here need a Hyprland restart. Everything is off by default.
-- ============================================================================
-- hl.config({ ecosystem = { enforce_permissions = true } })
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-- ============================================================================
-- 5. AUTOSTART: https://wiki.hypr.land/Configuring/Basics/Autostart/
-- Runs once at login. hyprctl reload does NOT re-run it.
-- ============================================================================
hl.on("hyprland.start", function ()
    hl.exec_cmd("waybar")
    -- Wallpaper: writes a temporary hyprpaper config, then starts hyprpaper.
    -- Change eDP-1 if your monitor has a different name (check: hyprctl monitors).
    hl.exec_cmd([[bash -c 'printf "wallpaper {\n    monitor = eDP-1\n    path = %s/misc/wallpaper.png\n    fit_mode = cover\n}\n\nsplash = false\n" "$HOME" > /tmp/hyprpaper.conf && hyprpaper -c /tmp/hyprpaper.conf']])
    hl.exec_cmd("protonvpn-app")
end)


-- ============================================================================
-- 6. INPUT: keyboard, mouse, touchpad
-- ============================================================================
hl.config({
    input = {
        kb_layout  = "gb",        -- "us" for a US keyboard
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0.5,       -- -1.0 to 1.0, 0 = no change

        touchpad = { natural_scroll = false },
    },
})

-- Settings for one specific device. Find names with: hyprctl devices
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


-- ============================================================================
-- 7. LAYOUTS: how windows tile (which layout is in use is set in ricing.lua)
-- https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
-- https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- ============================================================================
hl.config({
    dwindle   = { preserve_split = true },
    master    = { new_status = "master" },
    scrolling = { fullscreen_on_one_column = true },
})
-- Hyprland 0.55 also has a Layout API for writing your own layout in Lua (see the wiki).


-- ============================================================================
-- 8. MISC: odds and ends
-- ============================================================================
hl.config({
    misc = {
        force_default_wallpaper = -1,    -- 0 or 1 disables the anime mascot wallpapers
        disable_hyprland_logo   = true,
    },
})


-- ============================================================================
-- 9. KEYBINDS: https://wiki.hypr.land/Configuring/Basics/Binds/
-- Format: hl.bind("KEYS", action)   (SUPER + X means hold Super, press X)
-- ============================================================================

-- Open apps
hl.bind("SHIFT + Shift_R", hl.dsp.exec_cmd(terminal))      -- Right Shift = terminal
hl.bind(mod .. " + E",     hl.dsp.exec_cmd(menu))          -- launcher
hl.bind(mod .. " + A",     hl.dsp.exec_cmd(fileManager))   -- files
hl.bind(mod .. " + S",     hl.dsp.exec_cmd(browser))       -- browser

-- Screenshots (pick an area with the mouse)
hl.bind("PRINT",              hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))   -- copy to clipboard
hl.bind(mod .. " + PRINT",    hl.dsp.exec_cmd("hyprshot -m region -o $HOME/misc"))      -- save to ~/misc

-- Window control
hl.bind(mod .. " + W", hl.dsp.window.close())
hl.bind(mod .. " + Q", hl.dsp.window.fullscreen_state({ internal = 2, client = 0, action = "toggle" }))
hl.bind(mod .. " + X", hl.dsp.window.pseudo())

-- Move focus with the arrow keys
hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Move / resize windows with the mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })   -- left button drags
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })   -- right button resizes

-- Workspaces: SUPER + 1..0 switches, SUPER + SHIFT + 1..0 moves the window there
for i = 1, 10 do
    local key = i % 10    -- workspace 10 uses key 0
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad: a hidden workspace you can flick to and from
hl.bind(mod .. " + D", hl.dsp.workspace.toggle_special("magic"))

-- Scroll through workspaces
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Volume, brightness and media keys. locked = also works on the lock screen.
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Needs playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


-- ============================================================================
-- 10. PROTON VPN: SUPER + P hides/shows the VPN window (the VPN stays connected)
-- If the app isn't running, the key starts it. Needs jq.
-- ============================================================================
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

hl.bind(mod .. " + P", hl.dsp.exec_cmd("bash -c '" .. (vpn_toggle:gsub("'", "'\\''")) .. "'"))


-- ============================================================================
-- 11. RULES
-- ============================================================================

-- WINDOW RULES: https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- Ideas: per-app opacity, size, float, workspace, e.g.
-- hl.window_rule({ name = "kitty-fade", match = { class = "kitty" }, opacity = "0.9 0.8" })

hl.window_rule({
    -- Ignore maximize requests from apps
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class = "^$", title = "^$",
        xwayland = true, float = true, fullscreen = false, pin = false,
    },
    no_focus = true,
})

hl.window_rule({
    -- hyprland-run windows float at the bottom left
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- WORKSPACE RULES: https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps": no gaps or borders when there is only one window. Uncomment all four to use it.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({ name = "no-gaps-wtv1", match = { float = false, workspace = "w[tv1]" }, border_size = 0, rounding = 0 })
-- hl.window_rule({ name = "no-gaps-f1",   match = { float = false, workspace = "f[1]"   }, border_size = 0, rounding = 0 })

-- LAYER RULES: for bars, launchers, notifications (things that aren't normal windows).
-- Example: blur behind waybar (check the namespace with: hyprctl layers)
-- hl.layer_rule({ name = "blur-waybar", match = { namespace = "^waybar$" }, blur = true })
-- hl.layer_rule({ name = "no-anim-overlay", match = { namespace = "^my-overlay$" }, no_anim = true })
