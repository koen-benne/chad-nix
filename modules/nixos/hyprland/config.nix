# Shared Hyprland configuration
{ scripts, wrapCmd ? (cmd: cmd) }: ''
  monitor = eDP-1, 3024x1890@60, auto, 2
  # monitor = HDMI-A-1, 3440x1440@60, auto, 1

  exec-once = systemctl --user start hyprpolkitagent
  exec-once = ${wrapCmd "foot --server"}
  exec-once = ${wrapCmd "dms run"}
  exec-once = corectrl --minimize-systray
  exec-once = ${wrapCmd "nm-applet"}
  exec-once = hyprctl setcursor 24

  experimental {
    xx_color_management_v4 = true
  }

  device {
    name = apple-spi-trackpad
    sensitivity = -0.1
  }

  input {
    repeat_delay = 300
    repeat_rate = 50
    kb_layout = us

    follow_mouse = 1

    touchpad {
      natural_scroll = true
      scroll_factor = 0.5
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
    col.active_border = rgba(ca714eee)
    col.inactive_border = rgba(00000000)

    layout = master
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
      enabled = true
      size = 8
      passes = 1
      new_optimizations = true
      popups = true
    }
  }

  animations {
    enabled = true

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 3, myBezier
    animation = windowsOut, 1, 3, default, popin 80%
    animation = border, 1, 5, default
    animation = fade, 1, 3, default
    animation = workspaces, 1, 4, default
  }

  dwindle {
    pseudotile = yes
    preserve_split = yes
  }

  master {
    new_status = master
    new_on_top = true
  }

  gestures {
    workspace_swipe = off
  }

  # Window rules
  windowrule = float, title:(Floorp - Sharing Indicator)
  windowrule = tile, title:^(.*PWA.*)$
  windowrule = tile, title:(Spotify)

  windowrule = workspace 9, title:(Spotify)
  windowrule = stayfocused, class:^(pinentry-)

  $mainMod = SUPER

  bind = $mainMod, Return, exec, footclient
  bind = $mainMod, Q, killactive,
  bind = $mainMod CTRL SHIFT, C, exit,
  bind = $mainMod, E, exec, nautilus
  bind = $mainMod, V, togglefloating,
  bind = $mainMod, R, exec, dms ipc spotlight toggle
  bind = $mainMod, P, pseudo,
  bind = $mainMod, T, togglesplit,
  bind = $mainMod, F, fullscreen,
  bind = $mainMod, P, exec, 1password --quick-access
  bind = $mainMod, C, exec, hyprpicker -a
  bind = $mainMod, G, exec, grim -g "$(slurp)" ~/Images/$(date +%s)_grim.png
  bind = $mainMod SHIFT, G, exec, grim ~/Images/$(date +%s)_grim.png

  # DMS specific keybindings
  bind = $mainMod CTRL, N, exec, dms ipc notifications toggle
  bind = $mainMod CTRL, V, exec, dms ipc clipboard toggle
  bind = $mainMod CTRL, P, exec, dms ipc notepad toggle
  bind = $mainMod SHIFT, S, exec, dms ipc lock lock
  bind = $mainMod, X, exec, dms ipc powermenu toggle

  # Playerctl binds
  bind = , XF86AudioMedia, exec, playerctl play-pause
  bind = , XF86AudioPlay,  exec, playerctl play-pause
  bind = , XF86AudioPrev,  exec, playerctl previous
  bind = , XF86AudioNext,  exec, playerctl next
  bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-
  bind = , XF86AudioRaiseVolume, exec, wpctl set-volume --limit 1.0 @DEFAULT_AUDIO_SINK@ 10%+
  bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  bind = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
  bind = , XF86MonBrightnessDown, exec, brightnessctl s 10%-
  bind = , XF86MonBrightnessUp, exec, brightnessctl s +10%

  # Move focus the river way
  bind = $mainMod, J, layoutmsg, cyclenext
  bind = $mainMod, K, layoutmsg, cycleprev
  bind = $mainMod, H, layoutmsg, orientationleft
  bind = $mainMod, L, layoutmsg, orientationright
  bind = $mainMod, U, layoutmsg, orientationup
  bind = $mainMod, D, layoutmsg, orientationdown

  # Switch workspaces with mainMod + [0-9]
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

  # Master-layout specific binds
  bind = $mainMod, S, layoutmsg, swapwithmaster

  # Move/resize windows with keyboard
  bind = $mainMod SHIFT, H, resizeactive, -200 0
  bind = $mainMod SHIFT, L, resizeactive, 200 0
  bind = $mainMod SHIFT, K, resizeactive, 0 -100
  bind = $mainMod SHIFT, J, resizeactive, 0 100
  bind = $mainMod CTRL, H, moveactive, -200 0
  bind = $mainMod CTRL, L, moveactive, 200 0
  bind = $mainMod CTRL, K, moveactive, 0 -100
  bind = $mainMod CTRL, J, moveactive, 0 100

  # Move/resize windows with mainMod + LMB/RMB and dragging
  bindm = $mainMod, mouse:272, movewindow
  bindm = $mainMod, mouse:273, resizewindow

  # Scroll through existing workspaces with mainMod + scroll
  bind = $mainMod, mouse_down, workspace, e+1
  bind = $mainMod, mouse_up, workspace, e-1


''
