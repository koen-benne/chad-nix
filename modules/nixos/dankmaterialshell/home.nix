{
  pkgs,
  inputs,
  config,
  lib,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.dankmaterialshell;
in {
  imports = [
    inputs.dms.homeModules.dankMaterialShell.default
  ];

  options.my.dankmaterialshell = {
    enable = lib.mkEnableOption (lib.mdDoc "DankMaterialShell");
  };

  config = mkIf cfg.enable {
    programs.dankMaterialShell = {
      enable = true;
      dgop.package = pkgs.unstable.dgop;
      systemd = {
        enable = true;
        restartIfChanged = true;
      };

      # Default settings, can be overwritten by GUI settings
      default.settings = {
        lockBeforeSuspend = true;
        weatherLocation = "Gouda, Zuid-Holland";
        weatherCoordinates = "52.0181194,4.7111221";
        launcherLogoMode = "os";
      };

      # All features enabled by default, but can be overridden
      enableSystemMonitoring = true;
      # enableVPN = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;
    };
  };
}
