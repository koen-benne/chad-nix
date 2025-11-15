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
    my.waybar.enable = true;
    my.foot.enable = true;
    my.thunderbird.enable = true;
    my.qutebrowser.enable = true;
  };
}

