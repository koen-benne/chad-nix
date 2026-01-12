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
    inputs.dms.homeModules.dank-material-shell
  ];

  options.my.dankmaterialshell = {
    enable = lib.mkEnableOption (lib.mdDoc "DankMaterialShell");
  };

  config = mkIf cfg.enable {
    programs.dank-material-shell = {
      enable = true;
      dgop.package = pkgs.unstable.dgop;
      systemd = {
        enable = true;
        restartIfChanged = true;
      };

      # Default settings, can be overwritten by GUI settings
      settings = {
        lockBeforeSuspend = true;
        weatherLocation = "Gouda, Zuid-Holland";
        weatherCoordinates = "52.0181194,4.7111221";
        launcherLogoMode = "os";
        currentThemeName = "blue";

        # OSD (On-Screen Display) settings
        osdVolumeEnabled = true;
        osdBrightnessEnabled = true;
        osdMediaVolumeEnabled = true;
        osdMicMuteEnabled = true;
        osdCapsLockEnabled = true;
        osdIdleInhibitorEnabled = true;
        osdPowerProfileEnabled = true;
        osdAudioOutputEnabled = true;
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
