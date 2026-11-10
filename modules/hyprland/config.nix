# Shared Hyprland configuration
{
  scripts,
}: ''
  -- MSI MAG 341CQP QD-OLED - HDR enabled with 10-bit color
  hl.monitor({
    output   = "DP-3",
    mode     = "3440x1440@174.962",
    position = "auto",
    scale    = 1,

    -- HDR Configuration
    bitdepth = 10,
    cm       = "hdr",

    -- SDR → HDR Mapping
    sdr_min_luminance = 0.005,
    sdr_max_luminance = 230,
  })

  hl.on("hyprland.start", function()
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("foot --server")
    -- hl.exec_cmd("dms run")
    hl.exec_cmd("corectrl --minimize-systray")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("hyprctl setcursor 24")
  end)

  hl.config({
    render = {
      cm_enabled  = true,
      cm_sdr_eotf = "gamma22",
    },
  })

  hl.device({
    name        = "apple-spi-trackpad",
    sensitivity = -0.1,
  })

  hl.config({
    input = {
      repeat_delay = 300,
      repeat_rate  = 50,
      kb_layout    = "us",
      kb_options   = "caps:ctrl_modifier",

      follow_mouse = 1,

      touchpad = {
        natural_scroll = true,
        scroll_factor  = 0.5,
        tap_to_click = false,
      },

      sensitivity = -0.9,
    },
  })

  hl.config({
    misc = {
      disable_splash_rendering = true,
      disable_hyprland_logo    = true,
    },
  })

  hl.config({
    general = {
      gaps_in    = 5,
      gaps_out   = 10,
      border_size = 2,
      -- Border colors managed by DMS at runtime

      layout = "scrolling",
    },
  })

  hl.config({
    cursor = {
      inactive_timeout = 5,
    },
  })

  hl.config({
    decoration = {
      rounding = 10,

      shadow = {
        enabled      = true,
        range        = 4,
        render_power = 3,
        color        = "rgba(1a1a1aee)",
      },

      blur = {
        enabled = true,
        size    = 8,
        passes  = 1,
      },
    },
  })

  hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

  hl.animation({ leaf = "windows",    enabled = true, speed = 3, bezier = "myBezier" })
  hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "default", style = "popin 80%" })
  hl.animation({ leaf = "border",     enabled = true, speed = 5, bezier = "default" })
  hl.animation({ leaf = "fade",       enabled = true, speed = 3, bezier = "default" })
  hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "default", style = "slidevert" })

  hl.config({
    scrolling = {
      column_width            = 0.5,
      fullscreen_on_one_column = true,
      focus_fit_method        = 1,
      follow_focus            = true,
    },
  })

  -- Window rules
  hl.window_rule({ match = { title = "Floorp - Sharing Indicator" }, float = true })
  hl.window_rule({ match = { title = "^(.*PWA.*)$" },               tile  = true })
  hl.window_rule({ match = { title = "Spotify" },                    tile  = true })
  hl.window_rule({ match = { title = "Spotify" },                    workspace = "9" })
  hl.window_rule({ match = { class = "^(pinentry-)" },               stay_focused = true })

  local mainMod = "SUPER"

  hl.bind(mainMod .. " + Return",     hl.dsp.exec_cmd("footclient"))
  hl.bind(mainMod .. " + W",          hl.dsp.exec_cmd("zen-beta --name zen-beta"))
  hl.bind(mainMod .. " + Q",          hl.dsp.window.close())
  hl.bind(mainMod .. " + CTRL + SHIFT + C", hl.dsp.exit())
  hl.bind(mainMod .. " + E",          hl.dsp.exec_cmd("nautilus"))
  hl.bind(mainMod .. " + V",          hl.dsp.window.float({ action = "toggle" }))
  hl.bind(mainMod .. " + R",          hl.dsp.exec_cmd("dms ipc spotlight toggle"))

  hl.bind(mainMod .. " + F",          hl.dsp.window.fullscreen())
  hl.bind(mainMod .. " + P",          hl.dsp.exec_cmd("1password --quick-access"))
  hl.bind(mainMod .. " + C",          hl.dsp.exec_cmd("hyprpicker -a"))
  hl.bind(mainMod .. " + G",          hl.dsp.exec_cmd('grim -g "$(slurp)" ~/Images/$(date +%s)_grim.png'))
  hl.bind(mainMod .. " + SHIFT + G",  hl.dsp.exec_cmd("grim ~/Images/$(date +%s)_grim.png"))

  -- DMS specific keybindings
  hl.bind(mainMod .. " + B",                hl.dsp.exec_cmd("dms ipc call bar toggle index 0"))
  hl.bind(mainMod .. " + CTRL + N",         hl.dsp.exec_cmd("dms ipc notifications toggle"))
  hl.bind(mainMod .. " + CTRL + V",         hl.dsp.exec_cmd("dms ipc clipboard toggle"))
  hl.bind(mainMod .. " + CTRL + P",         hl.dsp.exec_cmd("dms ipc notepad toggle"))
  hl.bind(mainMod .. " + SHIFT + S",        hl.dsp.exec_cmd("dms ipc lock lock"))
  hl.bind(mainMod .. " + X",                hl.dsp.exec_cmd("dms ipc powermenu toggle"))
  hl.bind(mainMod .. " + S",                hl.dsp.exec_cmd("dms ipc call dankdash media"))
  hl.bind(mainMod .. " + Comma",            hl.dsp.exec_cmd("dms ipc call settings toggle"))

  -- Playerctl binds
  hl.bind("XF86AudioMedia",        hl.dsp.exec_cmd("playerctl play-pause"))
  hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"))
  hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"))
  hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"))
  hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("dms ipc call audio increment 3"))
  hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("dms ipc call audio decrement 3"))
  hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("dms ipc call audio mute"))
  hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("dms ipc call audio micmute"))
  hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd('dms ipc call brightness increment 5 ""'))
  hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd('dms ipc call brightness decrement 5 ""'))

  -- Move focus with vim-style directional keys
  hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
  hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
  hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
  hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))

  -- Switch workspaces with mainMod + [0-9]
  hl.bind(mainMod .. " + U",          hl.dsp.focus({ workspace = "e-1" }))
  hl.bind(mainMod .. " + I",          hl.dsp.focus({ workspace = "e+1" }))
  hl.bind(mainMod .. " + SHIFT + U",  hl.dsp.window.move({ workspace = "e-1" }))
  hl.bind(mainMod .. " + SHIFT + I",  hl.dsp.window.move({ workspace = "e+1" }))

  for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,          hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,  hl.dsp.window.move({ workspace = i }))
  end

  -- Scrolling-layout specific binds
  hl.bind(mainMod .. " + SHIFT + A",       hl.dsp.exec_cmd("hyprctl keyword general:layout scrolling"))
  hl.bind(mainMod .. " + M",               hl.dsp.exec_cmd("bash -c 'f=/tmp/hypr-col-full; if [ -f \"$f\" ]; then rm \"$f\"; hyprctl dispatch layoutmsg \"colresize 0.5\"; else touch \"$f\"; hyprctl dispatch layoutmsg \"colresize 1.0\"; fi'"))
  hl.bind(mainMod .. " + SHIFT + H",       hl.dsp.layout("swapcol l"))
  hl.bind(mainMod .. " + SHIFT + L",       hl.dsp.layout("swapcol r"))

  -- Column width
  hl.bind(mainMod .. " + SHIFT + comma",   hl.dsp.layout("colresize -0.1"))
  hl.bind(mainMod .. " + SHIFT + period",  hl.dsp.layout("colresize +0.1"))

  -- Vertical resize
  hl.bind(mainMod .. " + SHIFT + D",  hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
  hl.bind(mainMod .. " + CTRL + D",   hl.dsp.window.resize({ x = 0, y = 100,  relative = true }))

  -- Move/resize windows with mainMod + LMB/RMB and dragging
  hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
  hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

  -- Scroll through existing workspaces with mainMod + scroll
  hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
  hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

  -- Include DMS-managed configuration files
  -- No outputs because i want to manually be able to set HDR related stuff
  -- require("dms.outputs")
  require("dms.colors")
''
