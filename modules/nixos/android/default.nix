{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.my.android;
in {
  options.my.android = {
    enable = mkEnableOption "android";
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;
    users.users.${config.my.user}.extraGroups = ["adbusers"];

    environment.systemPackages = [pkgs.universal-android-debloater];
  };
}
