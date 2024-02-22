{ config, lib, pkgs, ... }:

let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.waybar;
in
{
  options.my.waybar = {
    enable = mkEnableOption (mdDoc "waybar");
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = [{
        layer = "top";
        # height = 26;
        modules-left = [ "wlr/taskbar" "hyprland/window" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right = [
          "cpu"
          "memory"
          "pulseaudio"
          "network"
          "clock"
        ];

        pulseaudio = {
          tooltip = false;
          scroll-step = 6;
          format = " {icon} {volume}%";
          format-muted = "󰝟 {volume}%";
          format-icons = {
            default = ["󰕿" "󰖀" "󰕾"];
          };
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-scroll-up = "pamixer -i 5";
          on-scroll-down = "pamixer -d 5";
        };
        "wlr/workspaces" = {
          sort-by-name = true;
          on-click = "activate";
          all-outputs = true;
        };

        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 14;
          icon-theme = "Numix-Circle";
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
          rewrite = {
            "Firefox Web Browser" = "Firefox";
            "Foot Server" = "Terminal";
          };
        };

        "hyprland/workspaces" = {
          format = "{icon}";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };

        "hyprland/window" = {
          max-length = 200;
          separate-outputs = true;
        };

        network = {
          interface = "enp4s0";
          # interface = "wlp3s0";
          tooltip = false;
          format = "{icon}";
          format-alt = "{ipaddr} {icon}";
          format-wifi = "  {essid} ({signalStrength}%)";
          format-ethernet = " {ifname}";
          format-disconnected = "睊";
          max-length = 50;
        };
        clock = {
          format = "{: %H:%M }";
          format-alt = "{: %H:%M %p   %d/%m/%Y}";
        };
        cpu = {
          interval = 15;
          on-click = "foot btop";
          format = " {}%";
          max-length = 10;
        };
        memory = {
          interval = 30;
          on-click = "foot btop";
          format = " {}%";
          max-length = 10;
        };
      }];
      style = ''



* {
  border: none;
  border-radius: 0px;
  font-family: "JetBrainsMonoNL Nerd Font";
  font-weight: bold;
  font-size: 16px;
  min-height: 10px;
}

window#waybar {
  background: rgba(35, 31, 32, 0.00);
  color: #dfd2c4;
}

tooltip {
  background: rgba(35, 31, 32, 0.00);
  color:      rgba(217, 216, 216, 1);
  border-radius: 7px;
  border-width: 0px;
}

#workspaces button {
  box-shadow: none;
  text-shadow: none;
  border-radius: 9px;
  padding: 3px 3px;
  color: #dfd2c4;
  animation: ws_normal 20s ease-in-out 1;
}

#workspaces button.active {
  background: #ca714e;
  color: #dfd2c4;
  margin-left: 3px;
  padding-left: 12px;
  padding-right: 12px;
  margin-right: 3px;
  animation: ws_active 20s ease-in-out 1;
  transition: all 0.4s cubic-bezier(.55,-0.68,.48,1.682);
}

#workspaces button:hover {
  background: #cc8a5e;
  color: #ffffee;
  animation: ws_hover 20s ease-in-out 1;
  transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
}

#taskbar button {
  box-shadow: none;
  text-shadow: none;
  border-radius: 9px;
  padding: 3px 3px;
  color: #dfd2c4;
  animation: ws_normal 20s ease-in-out 1;
  animation: tb_normal 20s ease-in-out 1;
}

#taskbar button.active {
  background: #ca714e;
  color: #dfd2c4;
  margin-left: 3px;
  padding-left: 12px;
  padding-right: 12px;
  margin-right: 3px;
  animation: tb_active 20s ease-in-out 1;
  transition: all 0.4s cubic-bezier(.55,-0.68,.48,1.682);
}

#taskbar button:hover {
  background: #cc8a5e;
  color: #ffffee;
  animation: tb_hover 20s ease-in-out 1;
  transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
}

#backlight,
#battery,
#bluetooth,
#clock,
#cpu,
#idle_inhibitor,
#language,
#memory,
#mpris,
#network,
#pulseaudio,
#tray {
  background: rgba(35, 31, 32, 0.00);
  color:      rgba(217, 216, 216, 1);
  opacity: 1;
  margin: 6px 0px;
  padding: 0 10px;
}

#workspaces,
#taskbar {
  margin: 6px 0px;
  padding: 0 6px;
}

#window {
  margin: 6px 0px;
}


.modules-left {
  margin-top: 8px;
  border-radius: 10px;
  margin-left: 20px;
  background: rgba(35, 31, 32, 0.70);
  padding: 0 10px;
}

.modules-center {
  margin-top: 8px;
  border-radius: 10px;
  background: rgba(35, 31, 32, 0.70);
}

.modules-right {
  padding-left: 10px;
  margin-top: 8px;
  border-radius: 10px;
  margin-right: 20px;
  background: rgba(35, 31, 32, 0.70);
}



      '';
    };
  };
}
