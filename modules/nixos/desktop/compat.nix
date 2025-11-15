{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption;
in {
  options.my.desktop = {
    enable = mkEnableOption "desktop";
  };
  options.networking.networkmanager = {
    enable = mkEnableOption "networkmanager";
  };

  config = lib.mkIf config.my.desktop.enable {
    my.hyprland.enable = true;
    my.lockscreen.enable = true;
    my.theme.enable = true;
    my.uxplay.enable = true;
    my.waybar.enable = true;
    my.foot.enable = true;
    my.thunderbird.enable = true;
    my.qutebrowser.enable = true;
  };
}

