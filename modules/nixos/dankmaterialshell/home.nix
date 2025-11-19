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
    # This is temporary untill there is a quickshell module in stable!!!
    (inputs.home-manager-unstable + "/modules/programs/quickshell.nix")
  ];

  options.my.dankmaterialshell = {
    enable = lib.mkEnableOption (lib.mdDoc "DankMaterialShell");
  };

  config = mkIf cfg.enable {
    # In case we want wallpaperengine
    home.packages = [
      pkgs.unstable.linux-wallpaperengine
    ];

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
