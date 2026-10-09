# Arch + Hyprland + Waybar

Run everything as your normal user, not root. Copy commands exactly, because spaces and quotes matter.

Safety: pacman packages come from Arch's official repos and are signed by Arch's maintainers. Only three packages in this guide come from the AUR (`yay`, `cliamp`, `brave-bin`). AUR packages are user-submitted and not vetted by Arch, so this guide shows you how to read their build scripts before installing.

Contents:
- Before you start: laptop checklist
- 0. Update the system
- 1. Install yay (AUR helper)
- 2. Install packages
- 3. Waybar
- 4. Wallpaper (hyprpaper)
- 5. Shell aliases
- 6. Hyprland config
- 7. VPN (Proton VPN)
- 8. Laptop battery life (TLP)
- 9. LazyVim, Neogit, Diffview and GitGraph
- 10. Moving to a new laptop
- 11. Cleanup

---

## Before you start: laptop checklist

The guide works on any Arch laptop, but these depend on the machine. Check them first:

- **Hyprland:** it must already be installed and working. This guide doesn't install it.
- **Graphics drivers:** Intel and AMD usually work out of the box. NVIDIA needs extra setup for Hyprland, so follow the NVIDIA page on the Hyprland wiki before continuing.
- **Wi-Fi and Bluetooth:** if either doesn't work, the usual fix is the firmware package, which is normally already installed:

```bash
sudo pacman -S --needed linux-firmware
```

- **Network manager:** the VPN in step 7 needs NetworkManager to run your Wi-Fi. If your Wi-Fi is handled by plain `iwd` or `systemd-networkd` instead, step 7 shows the switch. Have your Wi-Fi password ready for it.
- **Monitor name:** a laptop's built-in screen is almost always `eDP-1`, but confirm with `hyprctl monitors` (step 4).
- **Screen scaling:** high-resolution screens (the Surface Pro and some Framework models) can make text look tiny. `scale = "auto"` in `hyprland.lua` usually handles it. If it doesn't, set a fixed value such as `scale = 1.5`.
- **Keyboard layout:** `hyprland.lua` has `kb_layout = "gb"` (UK). Change it to match the keyboard, for example `"us"`.
- **Touchpad and mouse:** if it feels off, adjust `sensitivity` and `natural_scroll` in the `input` section of `hyprland.lua`.

Model-specific notes (check the Arch Wiki page for your exact model for details):

- **ThinkPad:** well supported. The function keys send the key names this guide's config uses.
- **Framework:** well supported. Keep the kernel and `linux-firmware` up to date, because newer Framework models need recent versions.
- **Microsoft Surface Pro:** the base setup works, but the touchscreen, pen and cameras may need the `linux-surface` kernel and drivers on top of normal Arch. That is a separate project with its own instructions, so read them before deciding to use it.

---

## 0. Update the system

```bash
sudo pacman -Syu
```

This guide assumes you're logged into a Hyprland session. Some later commands, like `hyprctl`, only work inside one.

---

## 1. Install yay (AUR helper)

Start in your home folder:

```bash
cd ~
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
```

Read the build script before building. In the `source=` line the URL should point to `github.com/Jguer/yay`:

```bash
cat PKGBUILD
```

Build and install, then check it works:

```bash
makepkg -si
yay --version
```

Once `yay --version` prints a version number, delete the build folder (this does not uninstall yay):

```bash
cd ~
rm -rf ~/yay
```

---

## 2. Install packages

Bar, wallpaper, brightness, screenshots and clipboard:

```bash
sudo pacman -S --needed waybar hyprpaper brightnessctl hyprshot grim slurp wl-clipboard
```

Media keys:

```bash
sudo pacman -S --needed playerctl
```

Editor (Neovim):

```bash
sudo pacman -S --needed neovim
```

Media player (VLC). `vlc-plugins-all` adds the codec and format plugins, which are split out of the main `vlc` package on Arch:

```bash
sudo pacman -S --needed vlc vlc-plugins-all
```

Office suite (LibreOffice, all from the official repos). `libreoffice-fresh-en-gb` and `hunspell-en_gb` give a British English interface and spell-check dictionary, so drop them if you don't want British English. `ttf-liberation` has fonts that match Arial, Times New Roman and Courier New, so Word documents keep their layout:

```bash
sudo pacman -S --needed libreoffice-fresh libreoffice-fresh-en-gb hunspell-en_gb ttf-liberation
```

Audio (needed for the volume keys and the Waybar `VOL` module):

```bash
sudo pacman -S --needed pipewire pipewire-pulse wireplumber
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

Check it works (a `*` should appear next to your default output):

```bash
wpctl status
```

Programs used by the Hyprland config (terminal, file manager, launcher, and Konsole so Dolphin can open files in a terminal):

```bash
sudo pacman -S --needed kitty dolphin hyprlauncher konsole
```

Archive support, so Dolphin can open and extract zip files (without it, double-clicking a zip just shows the "Open With" picker). `unzip`, `p7zip` and `unrar` add support for more formats and give you `unzip` in the terminal:

```bash
sudo pacman -S --needed ark unzip p7zip unrar
```

Fonts, only if the `☀` or `⚡` symbols in Waybar show up as boxes:

```bash
sudo pacman -S --needed ttf-dejavu noto-fonts
```

Emoji and extra language fonts, if emojis on websites show up as empty boxes or some characters are missing:

```bash
sudo pacman -S --needed noto-fonts-emoji noto-fonts-cjk noto-fonts-extra
fc-cache -fv
```

`noto-fonts-emoji` is the emoji font, `noto-fonts-cjk` covers Chinese, Japanese and Korean, and `noto-fonts-extra` adds more weights and rarer scripts. Restart Brave completely afterwards (close every window, not just the tab). To check the emoji font is picked up, `fc-match emoji` should print Noto Color Emoji.

GitHub login (optional). `git` is already installed in step 1 and works on its own, but `github-cli` gives you a simple way to log in to GitHub from the terminal (see "Backing up your config to GitHub" in step 6):

```bash
sudo pacman -S --needed github-cli
```

AUR packages. Read each build script first with the first command, and check that the `source=` URL points to the project's real site, with no `curl | sh` or unrelated domains. Then install:

```bash
yay -Gp cliamp
yay -S cliamp
```

```bash
yay -Gp brave-bin
yay -S brave-bin
```

---

## 3. Waybar

First make sure the config folders exist (`nano` won't create them):

```bash
mkdir -p ~/.config/waybar ~/.config/hypr
```

### Config

```bash
nano ~/.config/waybar/config.jsonc
```

```jsonc
{
    "layer": "top",
    "position": "top",
    "height": 32,

    "modules-left": [
        "hyprland/workspaces"
    ],

    "modules-center": [
        "clock"
    ],

    "modules-right": [
        "cpu",
        "memory",
        "network",
        "pulseaudio",
        "backlight",
        "battery"
    ],

    "hyprland/workspaces": {
        "format": "{name}",
        "on-click": "activate"
    },

    "clock": {
        "format": "{:%a %d %b   %H:%M}",
        "tooltip-format": "{:%A, %d %B %Y}"
    },

    "cpu": {
        "format": "CPU {usage}%"
    },

    "memory": {
        "format": "RAM {percentage}%"
    },

    "network": {
        "format-wifi": "WiFi {signalStrength}%",
        "format-ethernet": "Ethernet",
        "format-disconnected": "Offline"
    },

    "pulseaudio": {
        "format": "VOL {volume}%",
        "format-muted": "MUTED"
    },

    "backlight": {
        "format": "☀ {percent}%"
    },

    "battery": {
        "states": {
            "critical": 10
        },
        "format": "BAT {capacity}%",
        "format-charging": "BAT {capacity}% ⚡",
        "format-full": "BAT {capacity}%",
        "format-critical": "LOW BAT {capacity}%"
    }
}
```

The clock shows the date next to the time, for example `Sun 04 Oct   14:30`. Hovering over it shows the full date.

### Style

```bash
nano ~/.config/waybar/style.css
```

```css
* {
    font-family: sans-serif;
    font-size: 14px;
}

window#waybar {
    background: #111318;
    color: #ffffff;
}

#workspaces button {
    color: #ffffff;
    padding: 0 8px;
}

#workspaces button.active {
    background: #333842;
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
    color: #ff5555;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: steps(12);
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

@keyframes blink {
    to {
        background-color: #ff5555;
        color: #111318;
    }
}
```

At 10% battery or below (and not charging), the battery module turns red, flashes, and reads `LOW BAT`.

To test it, change `"critical": 10` to `"critical": 100` in `config.jsonc`, restart Waybar, and the warning should appear immediately. Change it back to `10` afterwards. Restart Waybar with:

```bash
pkill waybar; waybar &
```

Note: this warning is visual only. A pop-up notification would need a notification daemon, which this guide doesn't install.

### Notifications (dunst, optional)

Pop-up notifications (for example from Brave) need a notification daemon. This guide doesn't install one, but `archinstall`'s Hyprland profile includes `dunst`. If you set up Hyprland by hand and want notifications, install it. It's explicitly installed, so the cleanup in step 11 won't remove it:

```bash
sudo pacman -S --needed dunst
```

Check which daemon is running with `busctl --user status org.freedesktop.Notifications` (the `Comm=` line names it).

If a notification stays on screen until you click it, add a rule for it. This example hides Proton VPN notifications completely. To make them disappear after a few seconds instead, use `timeout = 5` in place of `skip_display = true`:

```bash
mkdir -p ~/.config/dunst/dunstrc.d
cat > ~/.config/dunst/dunstrc.d/10-protonvpn.conf <<'EOF'
[protonvpn]
    summary = "Proton VPN"
    skip_display = true
EOF
systemctl --user restart dunst
```

---

## 4. Wallpaper (hyprpaper)

Put your wallpaper at `~/misc/wallpaper.png` first.

Check your monitor name (run this inside a Hyprland session). It's usually `eDP-1` on a laptop:

```bash
hyprctl monitors
```

The wallpaper settings live in `hyprland.lua`, which writes a temporary hyprpaper config and starts hyprpaper at login. The autostart block already has it:

```lua
hl.exec_cmd([[bash -c 'printf "wallpaper {\n    monitor = eDP-1\n    path = %s/misc/wallpaper.png\n    fit_mode = cover\n}\n\nsplash = false\n" "$HOME" > /tmp/hyprpaper.conf && hyprpaper -c /tmp/hyprpaper.conf']])
```

Check the wallpaper file exists, then log out and back in to see it (`hyprctl reload` doesn't re-run autostart):

```bash
ls ~/misc/wallpaper.png
```

Notes:
- Change `eDP-1` in that line if `hyprctl monitors` shows a different name.
- The path uses `$HOME`, so it works for any username.
- `splash = false` hides the small random text ("better call vaxry") at the bottom of the screen. It's set here because hyprpaper draws over Hyprland's own splash.

### Login screen wallpaper (SDDM)

SDDM runs as its own user and can't read your home folder, so copy the wallpaper somewhere it can:

```bash
sudo mkdir -p /usr/share/backgrounds
sudo cp ~/misc/wallpaper.png /usr/share/backgrounds/
```

Set the `maldives` theme and point it at the wallpaper:

```bash
sudo mkdir -p /etc/sddm.conf.d
printf '[Theme]\nCurrent=maldives\n' | sudo tee /etc/sddm.conf.d/theme.conf
printf '[General]\nbackground=/usr/share/backgrounds/wallpaper.png\n' | sudo tee /usr/share/sddm/themes/maldives/theme.conf.user
```

Log out or reboot to see the result.

Notes:
- Setting the theme explicitly matters. If no theme is set, SDDM picks one itself, and it may pick one with no background option (`maya` shows a plain blue screen).
- The wallpaper goes in `theme.conf.user`, so a theme update won't overwrite it.

---

## 5. Shell aliases

```bash
nano ~/.bashrc
```

Add these lines at the bottom:

```bash
alias c="cliamp"
alias n="nvim"
```

Apply them to the current terminal (new terminals pick them up automatically):

```bash
source ~/.bashrc
```

Now `c` launches cliamp and `n` launches Neovim.

---

## 6. Hyprland config

```bash
nano ~/.config/hypr/hyprland.lua
```

Things to make sure are set in it:
- **Programs:** `terminal = "kitty"`, `fileManager = "dolphin"`, `menu = "hyprlauncher"`.
- **Browser:** `local browser = "brave"`. Use straight quotes, because Lua rejects curly ones. `brave-bin` is the package name, `brave` is the command.
- **Autostart:** launch `waybar`, `hyprpaper` and `protonvpn-app` on `hyprland.start`.
- **Keybinds used with this setup:**

```lua
hl.bind("SHIFT + Shift_R", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(browser))
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd("hyprshot -m region -o $HOME/misc"))
```

`PRINT` copies a selected area to the clipboard. `SUPER + PRINT` saves it to `~/misc` as well.

Reload keybind changes without logging out:

```bash
hyprctl reload
```

To test autostart, log out and back in (or reboot). `hyprctl reload` does not re-run `hyprland.start`, so waybar, hyprpaper and Proton VPN won't relaunch from it.

### Backing up your config to GitHub (optional)

GitHub doesn't accept your account password in the terminal, so log in with `github-cli` (step 2). Choose GitHub.com, HTTPS, and "Login with a web browser", then paste the one-time code into the browser. The second command lets git use that login:

```bash
gh auth login
gh auth setup-git
```

Tell git your name and email once, so commits are labelled properly. To keep your real email private, use the `...@users.noreply.github.com` address from GitHub's email settings:

```bash
git config --global user.name "your name"
git config --global user.email "you@example.com"
```

Create an empty repository on github.com first (leave "Add README" off), then push your config. Replace `YOUR_USERNAME` and `REPO_NAME`:

```bash
cd ~/.config/hypr
git init
git add .
git commit -m "initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/REPO_NAME.git
git push -u origin main
```

Later, after changing your config:

```bash
cd ~/.config/hypr
git add .
git commit -m "what you changed"
git push
```

A public repository shows everything in it to everyone, so check the files for anything private (tokens, API keys, personal paths) before pushing, or make the repository private.

---

## 7. VPN (Proton VPN)

The Proton VPN app is built on NetworkManager, so NetworkManager has to be the thing running your Wi-Fi. If `iwd` on its own or `systemd-networkd` handles it instead, the app thinks you're offline and drops the tunnel about 5 seconds after connecting, and with the kill switch on, your internet goes down with it.

### Check who manages your network

```bash
nmcli device status
```

If `wlan0` shows `connected` (not `disconnected` or `unmanaged`), NetworkManager already has your Wi-Fi and you can skip to "Install". If it doesn't, switch over below.

### Switch Wi-Fi to NetworkManager

Keep `iwd` as the Wi-Fi engine and let NetworkManager drive it. Have your Wi-Fi password ready, because the connection drops for a few seconds.

```bash
sudo pacman -S --needed networkmanager
sudo mkdir -p /etc/NetworkManager/conf.d
printf '[device]\nwifi.backend=iwd\n' | sudo tee /etc/NetworkManager/conf.d/wifi_backend.conf
```

Stop `systemd-networkd` for good (the sockets first, or they restart it), then start NetworkManager:

```bash
sudo systemctl disable --now systemd-networkd.socket systemd-networkd-varlink.socket systemd-networkd-resolve-hook.socket systemd-networkd-varlink-metrics.socket
sudo systemctl disable --now systemd-networkd
sudo systemctl enable --now NetworkManager
```

Connect to your Wi-Fi (replace `YourSSID` with your network name, keep the quotes). It asks for the password:

```bash
nmcli device wifi connect "YourSSID" --ask
```

Check it worked. `wlan0` should say `connected` and `systemd-networkd` should say `inactive`:

```bash
nmcli device status
systemctl is-active systemd-networkd
```

Don't disable `iwd`, because NetworkManager uses it. If anything goes wrong, this puts the old setup back:

```bash
sudo systemctl disable --now NetworkManager
sudo rm /etc/NetworkManager/conf.d/wifi_backend.conf
sudo systemctl enable --now systemd-networkd
```

The Waybar `network` module works the same under NetworkManager.

### Install

Proton's app needs a keyring to store your login:

```bash
sudo pacman -S --needed proton-vpn-gtk-app gnome-keyring
```

(If pacman can't find `proton-vpn-gtk-app`, it's available from the AUR instead. That would be a fourth AUR package, so read its build script first, the same way as in step 2: `yay -Gp proton-vpn-gtk-app`, then `yay -S proton-vpn-gtk-app`.)

Open Proton VPN from the launcher, log in, and connect. The free plan works. To check the tunnel is up, this should print an IP that isn't your own:

```bash
curl -s https://ifconfig.me; echo
```

Closing the app's window with the **X** quits it and drops the VPN (it asks you to confirm), and Hyprland has no minimise button. The next section adds a key that hides and shows the window instead.

### Hide and show the window (SUPER + P)

This adds one key that tucks the Proton VPN window away on a hidden workspace and brings it back. The VPN stays connected while it's hidden, and if the app isn't running the key launches it. It needs `jq`:

```bash
sudo pacman -S --needed jq
```

Create the script:

```bash
cat > ~/.config/hypr/protonvpn-toggle.sh <<'EOF'
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
EOF
chmod +x ~/.config/hypr/protonvpn-toggle.sh
```

If you're using the `hyprland.lua` from the hyprland repository, it already has the key and the autostart line, so skip the next two steps and just run `hyprctl reload`.

Check whether `SUPER + P` is already used (the default config binds it to pseudo-tiling):

```bash
grep -n '" + P"' ~/.config/hypr/hyprland.lua
```

If a line shows up, put `-- ` at the start of it so the two binds don't fight. Then add the key and reload:

```bash
echo 'hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("$HOME/.config/hypr/protonvpn-toggle.sh"))' >> ~/.config/hypr/hyprland.lua
hyprctl reload
```

Press `SUPER + P` to hide the window and `SUPER + P` again to show it. To use a different key, change the `P` in the last command.

Proton VPN also opens on login, through `hl.exec_cmd("protonvpn-app")` in the `hyprland.start` block of `hyprland.lua`. Its window appears on login, so hide it with `SUPER + P`. Autostart only runs on login, so `hyprctl reload` won't start it. Keep the app's own auto-connect setting off, because with it on you can get a "No server available in the current tier" popup at login.

If nothing happens, run the script by hand to see its error:

```bash
~/.config/hypr/protonvpn-toggle.sh
```

The script finds the window by its title, `Proton VPN`. Check Hyprland sees it with `hyprctl clients | grep -i proton`. Newer Hyprland uses Lua commands for `hyprctl dispatch`, which is why the script is written that way.

### If it still disconnects

- Make sure NetworkManager is running and enabled at boot: `sudo systemctl enable --now NetworkManager`.
- Free servers get busy. Try a different country or protocol in the app's settings.
- If your internet stays dead after a disconnect, leftover kill switch entries may be blocking it. List the connections and delete any `pvpn-killswitch...` ones (keep the quotes):

```bash
nmcli connection show
nmcli connection delete "pvpn-killswitch-ipv6"
```

- Read what NetworkManager logged around the drop:

```bash
journalctl -u NetworkManager -n 80 --no-pager
```

---

## 8. Laptop battery life (TLP)

Arch doesn't come with any power management, so install TLP. It applies sensible battery-saving settings automatically, with no configuration needed. It works on the ThinkPad, Framework and Surface Pro.

### Install and enable

```bash
sudo pacman -S --needed tlp
sudo systemctl enable --now tlp.service
```

### Avoid conflicts

TLP's documentation recommends masking these two services so they don't conflict with it:

```bash
sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
```

Don't run `power-profiles-daemon` alongside TLP. They conflict, so pick one. If the status check below warns that `power-profiles-daemon.service` is active, stop and mask it:

```bash
sudo systemctl mask --now power-profiles-daemon.service
```

If you uninstall `power-profiles-daemon` with pacman instead, reboot afterwards. The copy that's already running keeps going until then, so the warning stays.

### Check it's running

Look for `tlp = enabled` in the output, and no warnings:

```bash
sudo tlp-stat -s
```

### Charge limit (optional, protects battery health)

Stopping the battery at 80% instead of 100% makes it wear out more slowly. This suits a laptop that spends most of its time plugged in. Not every laptop supports it, so check first.

**1. Check whether your battery supports charge limits:**

```bash
sudo tlp-stat -b
```

Look at the `Supported features` line under `Battery Care`. If it says `none available` (and the threshold lines further down show `(not available)`), your laptop doesn't support charge limits, and this part doesn't apply. Skip to "Useful commands". If it lists supported features, continue.

**2. Find your battery's name.** It's usually `BAT0`, but some laptops use `BAT1`:

```bash
ls /sys/class/power_supply/
```

**3. Create the config.** Set `BAT` to the battery name you found in step 2 (change `BAT0` in the first line below if yours is different, for example `BAT1`), and change the numbers to taste. Charging stops at 80% and resumes when the battery drops below 75%:

```bash
BAT=BAT0
printf "START_CHARGE_THRESH_${BAT}=75\nSTOP_CHARGE_THRESH_${BAT}=80\n" | sudo tee /etc/tlp.d/01-battery.conf
```

**4. Apply it:**

```bash
sudo tlp start
```

**5. Check it took effect.** `tlp-stat -b` should now show your start and stop values:

```bash
sudo tlp-stat -b
```

Some laptops only support the stop value. If so, keep just the `STOP_CHARGE_THRESH_...` line.

### Useful commands

- `sudo tlp-stat -s` shows TLP's status and any warnings.
- `sudo tlp-stat -b` shows battery details and charge thresholds.
- `sudo tlp-stat -c` shows your active configuration.
- `sudo tlp fullcharge` charges to 100% once, for example before travelling. The limit applies again afterwards.
- `sudo tlp start` re-applies the settings after you change the config.

TLP is installed explicitly, so the cleanup in step 11 won't remove it.

---

## 9. LazyVim, Neogit, Diffview and GitGraph

Run this after everything above. LazyVim needs Neovim 0.11 or newer, which Arch's `neovim` package already is (installed in step 2). These packages are installed explicitly, so the cleanup in step 11 won't remove them.

### Dependencies

`git` and `base-devel` are already installed from step 1:

```bash
sudo pacman -S --needed neovim ripgrep fd lazygit tree-sitter-cli fzf imagemagick
```

kitty bundles its own Nerd Font symbols, so you don't need a separate font for the icons. `fzf` removes a `:checkhealth` warning, and `imagemagick` lets Neovim show images in kitty.

### Install LazyVim

This backs up any existing Neovim config first (a "No such file" error just means there wasn't one):

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git
```

### Add neogit, diffview and gitgraph

LazyVim loads every file in `lua/plugins/` automatically:

```bash
cat > ~/.config/nvim/lua/plugins/git-extras.lua <<'EOF'
return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Diffview" },
      { "<leader>gV", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    cmd = "Neogit",
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
    opts = {
      integrations = { diffview = true },
    },
  },
  {
    "isakbm/gitgraph.nvim",
    dependencies = { "sindrets/diffview.nvim" },
    keys = {
      {
        "<leader>gm",
        function()
          require("gitgraph").draw({}, { all = true, max_count = 5000 })
        end,
        desc = "Git graph",
      },
    },
    opts = {
      hooks = {
        on_select_commit = function(commit)
          vim.cmd("DiffviewOpen " .. commit.hash .. "^!")
        end,
        on_select_range_commit = function(from, to)
          vim.cmd("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
        end,
      },
    },
  },
}
EOF
```

### First launch

The `n` alias from step 5 runs `nvim`. Open it inside a git repo and let the plugins install. Treesitter also downloads its language parsers in the background, which takes a minute. When the messages stop, quit with `:qa` and reopen once:

```bash
cd ~/.config/hypr
n
```

Inside Neovim, check everything is healthy with `:checkhealth lazyvim`. The dashboard may show something like `4/35 plugins`. That is normal, because most plugins load only when used.

If `nvim` reports a missing `tree-sitter` or compiler error, make sure both `tree-sitter-cli` and `base-devel` are installed, then run `:TSUpdate`. To check the parsers installed, run `ls ~/.local/share/nvim/site/parser/`.

### Keys

`<leader>` is Space:

- `Space g n` opens Neogit.
- `Space g v` opens Diffview, and `Space g V` closes it.
- `Space g m` opens the git graph. Press Enter on a commit to open its diff in Diffview.

These keys don't clash with LazyVim's own git keys.

---

## 10. Moving to a new laptop

Your Hyprland config and your Neovim config each live in their own GitHub repository, so on a new laptop you clone them instead of rewriting anything. This guide lives in its own repository too: `https://github.com/clarhke/config-guide`.

- Hyprland config: `https://github.com/clarhke/hyprland`, restored to `~/.config/hypr`
- Neovim config: `https://github.com/clarhke/nvim`, restored to `~/.config/nvim`

### Before you start

Follow steps 0 to 2 first (update, yay and the packages). Also install the LazyVim dependencies from the LazyVim step:

```bash
sudo pacman -S --needed neovim ripgrep fd lazygit tree-sitter-cli fzf imagemagick
```

Hyprland must already be installed and working.

### Log in to GitHub

Cloning public repositories needs no login, but pushing does. This is the same as "Backing up your config to GitHub" in step 6:

```bash
gh auth login
gh auth setup-git
git config --global user.name "your name"
git config --global user.email "you@example.com"
```

### Restore the Hyprland config

A fresh Hyprland install creates its own `~/.config/hypr`, and `git clone` refuses a folder that isn't empty, so move it aside first (a "No such file" error just means there wasn't one):

```bash
mv ~/.config/hypr ~/.config/hypr.bak
git clone https://github.com/clarhke/hyprland.git ~/.config/hypr
```

### Restore the Neovim config

```bash
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/clarhke/nvim.git ~/.config/nvim
```

Then open Neovim with `nvim`. The first launch installs all the plugins and treesitter parsers, which takes a minute. When the messages stop, quit with `:qa` and reopen once. `lazy-lock.json` is in the repository, so you get the same plugin versions as before.

### Copy what isn't in the repositories

- **Wallpaper:** copy `~/misc/wallpaper.png` over from the old laptop (USB stick or cloud storage) into `~/misc`. Create the folder first with `mkdir -p ~/misc`.
- **Waybar:** the config and style are in step 3 of this guide, not in the repositories.
- **Shell aliases:** step 5.
- **System-level steps:** the SDDM login wallpaper (step 4), the VPN (step 7) and TLP (step 8) change files outside your home folder, so run them again.
- **Hardware settings:** `hyprland.lua` was written for the old laptop. Check the monitor name (`eDP-1` in the wallpaper line), `kb_layout` and the scale against "Before you start: laptop checklist" at the top of this guide.

Then log out and back in so autostart runs.

### Keep the repositories up to date

Anything you haven't pushed won't be on the new laptop. After changing a config:

```bash
cd ~/.config/hypr
git add .
git commit -m "what you changed"
git push
```

```bash
cd ~/.config/nvim
git add .
git commit -m "what you changed"
git push
```

---

## 11. Cleanup

Removes everything not needed. Run each block in order, after everything above is installed.

Remove known build leftovers (only the ones that are installed; a "no targets specified" error just means none were left):

```bash
sudo pacman -Rns --noconfirm $(pacman -Qq cliamp-debug yay-debug sdl2_sound-debug quickshell-git cmake ninja go 2>/dev/null)
```

Remove all orphaned dependencies, repeating until none are left (prints nothing if there are none):

```bash
while orphans=$(pacman -Qdtq); [ -n "$orphans" ]; do echo "Removing: $orphans"; sudo pacman -Rns --noconfirm $orphans || break; done
```

Clear the package caches (the first line removes half-finished download folders that make the cache clean error out; check there is no space before the `*`):

```bash
sudo rm -rf /var/cache/pacman/pkg/download-*
yay -Sc --noconfirm
```

Remove Go's leftover folders (the `chmod` is needed because Go makes them read-only):

```bash
chmod -R u+w ~/Downloads/go ~/go 2>/dev/null; rm -rf ~/Downloads/go ~/go
```

Check the result. The first command should list only `brave-bin`, `cliamp` and `yay`, and the second should print nothing:

```bash
pacman -Qm
pacman -Qdtq
```

Notes:
- This only removes packages that were installed as dependencies and that nothing needs. If it removes something you wanted, reinstall it with `sudo pacman -S <name>`.
- To protect a package from future cleanups, run `sudo pacman -D --asexplicit <name>`.
- Updating `cliamp` later rebuilds it, and `yay` will reinstall `go` temporarily. Run this step again afterwards.

### Packages that should remain (plus Hyprland and the base system)

Official Arch repos (signed by Arch's maintainers):

- base-devel
- git
- github-cli
- waybar
- hyprpaper
- brightnessctl
- hyprshot
- grim
- slurp
- wl-clipboard
- playerctl
- neovim
- vlc
- vlc-plugins-all
- pipewire
- pipewire-pulse
- wireplumber
- kitty
- dolphin
- hyprlauncher
- konsole
- ark
- unzip
- p7zip
- unrar
- ttf-dejavu
- noto-fonts
- noto-fonts-emoji
- noto-fonts-cjk
- noto-fonts-extra
- libreoffice-fresh
- libreoffice-fresh-en-gb
- hunspell-en_gb
- ttf-liberation
- networkmanager
- proton-vpn-gtk-app
- gnome-keyring
- jq
- tlp
- ripgrep
- fd
- lazygit
- tree-sitter-cli
- fzf
- imagemagick

AUR (user-submitted, not vetted by Arch):

- yay
- brave-bin
- cliamp
