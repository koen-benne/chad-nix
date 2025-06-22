{
  config,
  lib,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.plymouth;
in {
  options.my.plymouth = {
    enable = mkEnableOption (mdDoc "plymouth");
  };

  config = mkIf cfg.enable {
    boot.plymouth.enable = true;
    # I think this specifically only works on systemd-boot?
    boot.initrd.systemd.enable = true;
    boot.kernelParams = [
      "quiet"
      "splash"
      "plymouth.ignore-serial-consoles"
    ];
    boot.consoleLogLevel = 0;
    boot.initrd.verbose = false;
  };
}

