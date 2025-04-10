{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.android;
in {
  options.my.android = {
    enable = mkEnableOption (mdDoc "android");
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;
    users.users.${config.my.user}.extraGroups = ["adbusers"];

    environment.systemPackages = [pkgs.universal-android-debloater];
  };
}
