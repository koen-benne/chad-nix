{
  inputs,
  config,
  lib,
  pkgs,
  sys,
  ...
}: let
  inherit (lib) mkIf;
in {
  imports = [
    inputs.niri.homeModules.niri
    # inputs.niri.homeModules.config
    # inputs.niri.homeModules.stylix
  ];
  config = mkIf sys.my.niri.enable {
    programs.niri.enable = true;
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

      layout = {
        gaps = 10;
        center-focused-column = "never";
        preset-column-widths = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];
        default-column-width = { proportion = 0.5; };

        border = {
          width = 1;
        };
      };

      spawn-at-startup = [
        { command = ["systemctl" "--user" "start" "niri-flake-polkit"]; }
        { command = ["foot" "--server"]; }
      ] ++ lib.optionals (sys.my.desktop.panelStyle == "waybar") [
        { command = ["wpaperd"]; }
        { command = ["waybar"]; }
      ] ++ lib.optionals (sys.my.desktop.panelStyle == "dms") [
        { command = ["dms" "run"]; }
      ] ++ [
        { command = ["nm-applet"]; }
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
        "Mod+w".action = spawn "zen";
        "Mod+q".action = close-window;
        "Mod+Ctrl+Shift+c".action = quit;
        "Mod+e".action = spawn "nautilus";
        "Mod+v".action = toggle-window-floating;
        "Mod+r".action = spawn "fuzzel";
        "Mod+f".action = fullscreen-window;
        "Mod+p".action = spawn "1password" "--quick-access";
        "Mod+c".action = spawn "hyprpicker" "-a";
        "Mod+g".action = spawn "sh" "-c" "grim -g \"$(slurp)\" ~/Images/$(date +%s)_grim.png";
        "Mod+Shift+g".action = spawn "sh" "-c" "grim ~/Images/$(date +%s)_grim.png";
        "Mod+Shift+Slash".action = show-hotkey-overlay;

        "XF86AudioMedia".action = spawn "playerctl" "play-pause";
        "XF86AudioPlay".action = spawn "playerctl" "play-pause";
        "XF86AudioPrev".action = spawn "playerctl" "previous";
        "XF86AudioNext".action = spawn "playerctl" "next";
        "XF86AudioLowerVolume".action = spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "10%-";
        "XF86AudioRaiseVolume".action = spawn "wpctl" "set-volume" "--limit" "1.0" "@DEFAULT_AUDIO_SINK@" "10%+";
        "XF86AudioMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
        "XF86AudioMicMute".action = spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle";
        "XF86MonBrightnessDown".action = spawn "brightnessctl" "s" "10%-";
        "XF86MonBrightnessUp".action = spawn "brightnessctl" "s" "+10%";

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
      } // lib.optionalAttrs (sys.my.desktop.panelStyle == "waybar") {
        "Mod+Shift+w".action = spawn "sh" "-c" "pkill waybar && waybar";
      };

      prefer-no-csd = true;

      window-rules = [
        {
          matches = [{ is-active = false; }];
          opacity = 0.9;
        }
        {
          matches = [{ app-id = "^org\\.gnome\\.Nautilus$"; }];
          default-column-width = { proportion = 0.33333; };
        }
        {
          matches = [{ title = "^.*PWA.*$"; }];
        }
        {
          matches = [{ title = "^Spotify$"; }];
        }
        {
          matches = [{ app-id = "^foot$"; }];
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
