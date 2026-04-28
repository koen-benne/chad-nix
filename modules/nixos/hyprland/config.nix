# Shared Hyprland configuration
{
  scripts,
}: ''
  # MSI MAG 341CQP QD-OLED - HDR enabled with 10-bit color
  monitorv2 {
    output = DP-3
    mode = 3440x1440@174.962
    position = auto
    scale = 1

    # HDR Configuration
    bitdepth = 10
    cm = hdr
    supports_hdr = 1
    supports_wide_color = 1

    # Luminance Settings Based on Your Monitor's Performance
    min_luminance = 0.0
    max_luminance = 480
    max_avg_luminance = 254

    # SDR → HDR Mapping
    sdr_min_luminance = 0.005
    sdr_max_luminance = 230
  }

  exec-once = wl-paste --watch cliphist store
  exec-once = systemctl --user start hyprpolkitagent
  exec-once = foot --server
  # exec-once = dms run
  exec-once = corectrl --minimize-systray
  exec-once = nm-applet
  exec-once = hyprctl setcursor 24

  render {
    cm_enabled = true
    cm_sdr_eotf = gamma22
  }

  device {
    name = apple-spi-trackpad
    sensitivity = -0.1
  }

  input {
    repeat_delay = 300
    repeat_rate = 50
    kb_layout = us
    kb_options = caps:ctrl_modifier

    follow_mouse = 1

    touchpad {
      natural_scroll = true
      scroll_factor = 0.5
      tap-to-click = false
    }

    sensitivity = -0.9 # -1.0 - 1.0, 0 means no modification.
  }

  misc {
    disable_splash_rendering = true
    disable_hyprland_logo = true
  }

  general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    # Border colors are managed by DMS in dms/colors.conf
    col.active_border = rgba(ca714eee)
    col.inactive_border = rgba(00000000)

    layout = scrolling
  }

  cursor {
    inactive_timeout = 5
  }

  decoration {
    rounding = 10

    shadow {
      enabled = true
      range = 4
      render_power = 3
      color = rgba(1a1a1aee)
    }

    blur {
      enabled = false
      size = 8
      passes = 1
    }
  }

  animations {
    enabled = true

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 3, myBezier
    animation = windowsOut, 1, 3, default, popin 80%
    animation = border, 1, 5, default
    animation = fade, 1, 3, default
    animation = workspaces, 1, 4, default, slide_vertical
  }

  scrolling {
    column_width = 0.5
    fullscreen_on_one_column = true
    focus_fit_method = 1
    follow_focus = true
  }

  # Window rules
  windowrule = match:title (Floorp - Sharing Indicator), float on
  windowrule = match:title ^(.*PWA.*)$, tile on
  windowrule = match:title (Spotify), tile on
  windowrule = match:title (Spotify), workspace 9
  windowrule = match:class ^(pinentry-), stay_focused on

  $mainMod = SUPER

  bind = $mainMod, Return, exec, footclient
  bind = $mainMod, W, exec, zen-beta --name zen-beta
  bind = $mainMod, Q, killactive,
  bind = $mainMod CTRL SHIFT, C, exit,
  bind = $mainMod, E, exec, nautilus
  bind = $mainMod, V, togglefloating,
  bind = $mainMod, R, exec, dms ipc spotlight toggle
  bind = $mainMod, T, togglesplit,
  bind = $mainMod, F, fullscreen,
  bind = $mainMod, P, exec, 1password --quick-access
  bind = $mainMod, C, exec, hyprpicker -a
  bind = $mainMod, G, exec, grim -g "$(slurp)" ~/Images/$(date +%s)_grim.png
  bind = $mainMod SHIFT, G, exec, grim ~/Images/$(date +%s)_grim.png

  # DMS specific keybindings
  bind = $mainMod, B, exec, dms ipc call bar toggle index 0
  bind = $mainMod CTRL, N, exec, dms ipc notifications toggle
  bind = $mainMod CTRL, V, exec, dms ipc clipboard toggle
  bind = $mainMod CTRL, P, exec, dms ipc notepad toggle
  bind = $mainMod SHIFT, S, exec, dms ipc lock lock
  bind = $mainMod, X, exec, dms ipc powermenu toggle
  bind = $mainMod, S, exec, dms ipc call dankdash media
  bind = $mainMod, Comma, exec, dms ipc call settings toggle

  # Playerctl binds
  bind = , XF86AudioMedia, exec, playerctl play-pause
  bind = , XF86AudioPlay,  exec, playerctl play-pause
  bind = , XF86AudioPrev,  exec, playerctl previous
  bind = , XF86AudioNext,  exec, playerctl next
  bind = , XF86AudioRaiseVolume, exec, dms ipc call audio increment 3
  bind = , XF86AudioLowerVolume, exec, dms ipc call audio decrement 3
  bind = , XF86AudioMute, exec, dms ipc call audio mute
  bind = , XF86AudioMicMute, exec, dms ipc call audio micmute
  bind = , XF86MonBrightnessUp, exec, dms ipc call brightness increment 5 ""
  bind = , XF86MonBrightnessDown, exec, dms ipc call brightness decrement 5 ""

  # Move focus with vim-style directional keys
  bind = $mainMod, J, movefocus, d
  bind = $mainMod, K, movefocus, u
  bind = $mainMod, H, movefocus, l
  bind = $mainMod, L, movefocus, r

  # Switch workspaces with mainMod + [0-9]
  bind = $mainMod, U, workspace, e-1
  bind = $mainMod, I, workspace, e+1
  bind = $mainMod SHIFT, U, movetoworkspace, e-1
  bind = $mainMod SHIFT, I, movetoworkspace, e+1
  bind = $mainMod, 1, workspace, 1
  bind = $mainMod, 2, workspace, 2
  bind = $mainMod, 3, workspace, 3
  bind = $mainMod, 4, workspace, 4
  bind = $mainMod, 5, workspace, 5
  bind = $mainMod, 6, workspace, 6
  bind = $mainMod, 7, workspace, 7
  bind = $mainMod, 8, workspace, 8
  bind = $mainMod, 9, workspace, 9
  bind = $mainMod, 0, workspace, 10

  # Move active window to a workspace with mainMod + SHIFT + [0-9]
  bind = $mainMod SHIFT, 1, movetoworkspace, 1
  bind = $mainMod SHIFT, 2, movetoworkspace, 2
  bind = $mainMod SHIFT, 3, movetoworkspace, 3
  bind = $mainMod SHIFT, 4, movetoworkspace, 4
  bind = $mainMod SHIFT, 5, movetoworkspace, 5
  bind = $mainMod SHIFT, 6, movetoworkspace, 6
  bind = $mainMod SHIFT, 7, movetoworkspace, 7
  bind = $mainMod SHIFT, 8, movetoworkspace, 8
  bind = $mainMod SHIFT, 9, movetoworkspace, 9
  bind = $mainMod SHIFT, 0, movetoworkspace, 10

  # Scrolling-layout specific binds
  bind = $mainMod SHIFT, A, exec, hyprctl keyword general:layout scrolling
  bind = $mainMod, M, exec, bash -c 'f=/tmp/hypr-col-full; if [ -f "$f" ]; then rm "$f"; hyprctl dispatch layoutmsg "colresize 0.5"; else touch "$f"; hyprctl dispatch layoutmsg "colresize 1.0"; fi'
  bind = $mainMod SHIFT, H, layoutmsg, swapcol l
  bind = $mainMod SHIFT, L, layoutmsg, swapcol r

  # Column width (matching niri Shift+Comma / Shift+Period)
  bind = $mainMod SHIFT, comma, layoutmsg, colresize -0.1
  bind = $mainMod SHIFT, period, layoutmsg, colresize +0.1

  # Vertical resize (no niri equivalent)
  bind = $mainMod SHIFT, D, resizeactive, 0 -100
  bind = $mainMod CTRL, D, resizeactive, 0 100

  # Move/resize windows with mainMod + LMB/RMB and dragging
  bindm = $mainMod, mouse:272, movewindow
  bindm = $mainMod, mouse:273, resizewindow

  # Scroll through existing workspaces with mainMod + scroll
  bind = $mainMod, mouse_down, workspace, e+1
  bind = $mainMod, mouse_up, workspace, e-1

  # Include DMS-managed configuration files (optional)
  # These files are created/updated by DMS at runtime
  # No outputs because i want to manually be able to set HDR related stuff
  # source = ~/.config/hypr/dms/outputs.conf
  source = ~/.config/hypr/dms/colors.conf
''
