{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkForce;
  cfg = config.my.theme;
  swaylockEnable = config.programs.swaylock.enable;
in {
  options.my.theme = {
    enable = mkEnableOption (mdDoc "theme");
  };

  config = mkIf cfg.enable {
    # @release-24.11: remove this hyprpaper block, as it is no longer necessary in this release
    services.hyprpaper = {
      enable = true;
      settings = {
        preload = [ "${config.stylix.image}" ];
        wallpaper = [ ",${config.stylix.image}" ];
      };
    };
    home.packages = with pkgs; [ hyprpaper ];
    wayland.windowManager.hyprland.settings = {
      exec-once = [ "hyprpaper" ];
    };

    stylix = {
      targets = {
        # Enable on newer stylix version
        # neovim.enable = false;
        waybar.enable = false;
        fuzzel.enable = false;
        fzf.enable = false;
      };
      opacity = {
        popups = 0.8;
        terminal = 0.7;
      };
    };

    programs.swaylock.settings = mkIf swaylockEnable {
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      effect-blur = "7x5";
      line-color = "00000000";
      separator-color = "00000000";
      grace = 2;
      fade-in = 0.2;
    };
  };
}
