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

  config.my.waybar.enable = true;
  config.my.foot.enable = true;
}

