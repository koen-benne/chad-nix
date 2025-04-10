{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.bluetooth;
in {
  options.my.bluetooth = {
    enable = mkEnableOption (mdDoc "bluetooth");
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    # services.blueman.enable = true;

    # Use newer blueman
    environment.systemPackages = [pkgs.unstable.blueman];
    services.dbus.packages = [pkgs.unstable.blueman];
    systemd.packages = [pkgs.unstable.blueman];
  };
}
