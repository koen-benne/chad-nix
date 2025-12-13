{
  config,
  lib,
  pkgs,
  inputs,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  cfg = sys.my.niri;
in {
  config = mkIf cfg.enable {
    # Polkit agent package for both NixOS and standalone modes
    home.packages = [
      pkgs.polkit_gnome
    ];

    programs.niri.settings = {
      outputs."eDP-1" = {
        scale = 2.0;
        mode = {
          width = 3024;
          height = 1890;
          refresh = 60.0;
        };
      };

      input = {
        keyboard.xkb = {
          layout = "us";
        };

        touchpad = {
          natural-scroll = true;
          scroll-factor = 0.5;
          tap = true;
        };
      };

      cursor = {
        hide-after-inactive-ms = 5000;
      };

      hotkey-overlay = {
        skip-at-startup = true;
      };

      layout = {
        gaps = 10;
        center-focused-column = "never";
        preset-column-widths = [
          {proportion = 0.33333;}
          {proportion = 0.5;}
          {proportion = 0.66667;}
        ];
        default-column-width = {proportion = 0.5;};

        border = {
          width = 2;
        };
      };

      spawn-at-startup = [
        {command = ["wl-paste" "--watch" "cliphist" "store"];}
        {command = ["${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"];}
        {command = ["foot" "--server"];}
      ];

      environment = {
        NIXOS_OZONE_WL = "1";
      };

      xwayland-satellite = {
        enable = true;
        path = "${pkgs.xwayland-satellite-unstable}/bin/xwayland-satellite";
      };

      binds = with config.lib.niri.actions; {
        "Mod+Return".action = spawn "footclient";
        "Mod+w".action = spawn ["zen-beta" "--name" "zen-beta"];
        "Mod+q".action = close-window;
        "Mod+Ctrl+Shift+c".action = quit;
        "Mod+e".action = spawn "nautilus";
        "Mod+v".action = toggle-window-floating;
        "Mod+f".action = fullscreen-window;
        "Mod+p".action = spawn "1password" "--quick-access";
        "Mod+c".action = spawn "hyprpicker" "-a";
        # Very weird, will maybe be fixed in the future
        "Mod+g".action.screenshot = [];
        "Mod+Shift+g".action.screenshot-screen = [];
        "Mod+Shift+Slash".action = show-hotkey-overlay;

        # DMS specific
        "Mod+Ctrl+n".action = spawn "dms" "ipc" "call" "notifications" "toggle";
        "Mod+Ctrl+v".action = spawn "dms" "ipc" "call" "clipboard" "toggle";
        "Mod+Ctrl+p".action = spawn "dms" "ipc" "call" "notepad" "toggle";
        "Mod+Shift+s".action = spawn "dms" "ipc" "call" "lock" "lock";
        "Mod+x".action = spawn "dms" "ipc" "call" "powermenu" "toggle";
        "Mod+r".action = spawn "dms" "ipc" "call" "spotlight" "toggle";
        "Mod+s".action = spawn "dms" "ipc" "call" "dankdash" "media";
        "Mod+Comma".action = spawn "dms" "ipc" "call" "settings" "toggle";

        # Overview and focus switching
        "Mod+Tab".action = toggle-overview;
        "Mod+space".action = switch-focus-between-floating-and-tiling;

        "XF86AudioMedia" = {
          action = spawn "playerctl" "play-pause";
          allow-when-locked = true;
        };
        "XF86AudioPlay" = {
          action = spawn "playerctl" "play-pause";
          allow-when-locked = true;
        };
        "XF86AudioPrev" = {
          action = spawn "playerctl" "previous";
          allow-when-locked = true;
        };
        "XF86AudioNext" = {
          action = spawn "playerctl" "next";
          allow-when-locked = true;
        };

        "XF86AudioRaiseVolume" = {
          action = spawn "dms" "ipc" "call" "audio" "increment" "3";
          allow-when-locked = true;
        };
        "XF86AudioLowerVolume" = {
          action = spawn "dms" "ipc" "call" "audio" "decrement" "3";
          allow-when-locked = true;
        };
        "XF86AudioMute" = {
          action = spawn "dms" "ipc" "call" "audio" "mute";
          allow-when-locked = true;
        };
        "XF86AudioMicMute" = {
          action = spawn "dms" "ipc" "call" "audio" "micmute";
          allow-when-locked = true;
        };
        "XF86MonBrightnessUp" = {
          action = spawn "dms" "ipc" "call" "brightness" "increment" "5" "";
          allow-when-locked = true;
        };
        "XF86MonBrightnessDown" = {
          action = spawn "dms" "ipc" "call" "brightness" "decrement" "5" "";
          allow-when-locked = true;
        };

        "Mod+h".action = focus-column-left;
        "Mod+l".action = focus-column-right;
        "Mod+j".action = focus-window-down;
        "Mod+k".action = focus-window-up;

        "Mod+Shift+h".action = move-column-left;
        "Mod+Shift+l".action = move-column-right;
        "Mod+Shift+j".action = move-window-down;
        "Mod+Shift+k".action = move-window-up;

        "Mod+u".action = focus-workspace-down;
        "Mod+i".action = focus-workspace-up;
        "Mod+Page_Down".action = focus-workspace-down;
        "Mod+Page_Up".action = focus-workspace-up;

        "Mod+Shift+u".action = move-column-to-workspace-down;
        "Mod+Shift+i".action = move-column-to-workspace-up;
        "Mod+Shift+Page_Down".action = move-column-to-workspace-down;
        "Mod+Shift+Page_Up".action = move-column-to-workspace-up;

        # Numbered workspace bindings (niri is dynamic but supports these as "best effort")
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;

        "Mod+Shift+1".action.move-column-to-workspace = 1;
        "Mod+Shift+2".action.move-column-to-workspace = 2;
        "Mod+Shift+3".action.move-column-to-workspace = 3;
        "Mod+Shift+4".action.move-column-to-workspace = 4;
        "Mod+Shift+5".action.move-column-to-workspace = 5;
        "Mod+Shift+6".action.move-column-to-workspace = 6;
        "Mod+Shift+7".action.move-column-to-workspace = 7;
        "Mod+Shift+8".action.move-column-to-workspace = 8;
        "Mod+Shift+9".action.move-column-to-workspace = 9;

        "Mod+Ctrl+h".action = consume-window-into-column;
        "Mod+Ctrl+l".action = expel-window-from-column;

        # Window resizing bindings
        "Mod+n".action = set-column-width "+10%";
        "Mod+minus".action = set-column-width "-10%";
        "Mod+Shift+n".action = set-window-height "+10%";
        "Mod+Shift+minus".action = set-window-height "-10%";

        # Maximize window (fill screen without fullscreen)
        "Mod+m".action = maximize-column;

        "Mod+WheelScrollDown".action = focus-workspace-down;
        "Mod+WheelScrollUp".action = focus-workspace-up;
        "Mod+Shift+WheelScrollDown".action = move-column-to-workspace-down;
        "Mod+Shift+WheelScrollUp".action = move-column-to-workspace-up;

        # "Mod+Ctrl+Shift+l".action = spawn "hyprlock";
      };

      gestures = {
        hot-corners = "off";
      };

      prefer-no-csd = true;

      window-rules = [
        {
          matches = [
            {app-id = "^org\.keepassxc\.KeePassXC$";}
            {app-id = "^org\.gnome\.World\.Secrets$";}
            {app-id = "^1Password$";}
          ];

          block-out-from = "screencast";
        }
        {
          matches = [{is-active = false;}];
          opacity = 0.99;
        }
        {
          matches = [{app-id = "^org\\.gnome\\.Nautilus$";}];
          default-column-width = {proportion = 0.33333;};
        }
        {
          matches = [{title = "^.*PWA.*$";}];
        }
        {
          matches = [{title = "^Spotify$";}];
        }
        {
          matches = [{app-id = "^foot$";}];
        }
        {
          matches = [{}];
          geometry-corner-radius = {
            top-left = 8.0;
            top-right = 8.0;
            bottom-left = 8.0;
            bottom-right = 8.0;
          };
          clip-to-geometry = true;
        }
      ];
    };
  };
}
