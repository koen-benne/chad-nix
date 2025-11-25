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
    # Import quickshell module from home-manager-unstable since dms needs it
    # but it's not available in stable 25.05 yet
    (inputs.home-manager-unstable + "/modules/programs/quickshell.nix")
  ];

  options.my.dankmaterialshell = {
    enable = lib.mkEnableOption (lib.mdDoc "DankMaterialShell");
  };

  config = mkIf cfg.enable {
    programs.dankMaterialShell = {
      enable = true;
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
      enableClipboard = true;
      # enableVPN = true;
      enableBrightnessControl = true;
      enableColorPicker = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;
      enableSystemSound = true;
    };
  };
}
