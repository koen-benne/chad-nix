{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkForce;
  cfg = config.my.theme;
in {
  options.my.theme = {
    enable = mkEnableOption (mdDoc "theme");
  };

  config = mkIf cfg.enable {
    stylix = {
      targets = {
        neovim.enable = false;
        waybar.enable = false;
        fuzzel.enable = false;
        fzf.enable = false;
      };
      opacity = {
        popups = 0.8;
        terminal = 0.7;
      };
    };
    programs.hyprlock.settings = {
      background = {
        blur_passes = 3;
        blur_size = 10;
      };
      input-field = {
        size = "250, 50";
        outline_thickness = 3;
        dots_size = 0.33;
        dots_spacing = 0.15;
        dots_center = true;
        placeholder_text = ''<i>Password...</i>'';
        hide_input = false;
        position = "0, 200";
        halign = "center";
        valign = "bottom";
      };
      # image = {
      #   path = "${config.stylix.image}";
      #   size = "230, 250";
      #   rounding = -1;
      #   border_size = 2;
      #   rotate = 0;
      #   reload_time = -1;
      #   position = "0, 300";
      #   halign = "center";
      #   valign = "bottom";
      # };
      label = [
        {
          text = ''cmd[update:18000000] echo "<b> "$(date +'%A, %-d %B %Y')" </b>"'';
          font_size = 34;
          position = "0, -150";
          halign = "center";
          valign = "top";
        }
        {
          text = ''cmd[update:18000000] echo "<b> "$(date +'Week %U')" </b>"'';
          font_size = 24;
          position = "0, -250";
          halign = "center";
          valign = "top";
        }
        {
          text = ''cmd[update:1000] echo "<b><big> $(date +"%H:%M:%S") </big></b>"'';
          font_size = 94;
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
        {
          text = "   $USER";
          font_size = 18;
          position = "0, 100";
          halign = "center";
          valign = "bottom";
        }
        {
          text = ''cmd[update:60000] echo "<b> "$(uptime -p || $Scripts/UptimeNixOS.sh)" </b>"'';
          font_size = 24;
          position = "0, 0";
          halign = "right";
          valign = "bottom";
        }
        {
          text = ''cmd[update:3600000] [ -f ~/.cache/.weather_cache ] && cat  ~/.cache/.weather_cache'';
          font_size = 24;
          position = "50, 0";
          halign = "left";
          valign = "bottom";
        }
      ];
    };
  };
}
