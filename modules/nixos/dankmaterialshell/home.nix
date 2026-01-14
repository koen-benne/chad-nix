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
  jsonFormat = pkgs.formats.json {};
in {
  imports = [
    inputs.dms.homeModules.dank-material-shell
  ];

  options.my.dankmaterialshell = {
    enable = lib.mkEnableOption (lib.mdDoc "DankMaterialShell");

    defaultSettings = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = lib.mdDoc "Default settings to include in settings-default.json. Will be copied to settings.json on first run.";
    };
  };

  config = let
    # Merge user-provided defaultSettings with our base defaults
    defaultSettings = {
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
    } // cfg.defaultSettings;

    # Generate the settings JSON
    settingsJson = jsonFormat.generate "settings-default.json" defaultSettings;
  in mkIf cfg.enable {
    programs.dank-material-shell = {
      enable = true;
      dgop.package = pkgs.unstable.dgop;
      systemd = {
        enable = true;
        restartIfChanged = true;
      };

      # Leave settings empty to prevent DMS module from creating settings.json
      settings = {};

      # All features enabled by default, but can be overridden
      enableSystemMonitoring = true;
      # enableVPN = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;
    };

    # Create settings-default.json with our generated JSON
    xdg.configFile."DankMaterialShell/settings-default.json" = {
      source = settingsJson;
    };

    # Copy default to settings.json on first run only
    home.activation.initDmsSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
      SETTINGS_FILE="${config.xdg.configHome}/DankMaterialShell/settings.json"
      DEFAULT_FILE="${config.xdg.configHome}/DankMaterialShell/settings-default.json"

      if [ ! -f "$SETTINGS_FILE" ]; then
        if [ -L "$DEFAULT_FILE" ]; then
          $DRY_RUN_CMD mkdir -p "${config.xdg.configHome}/DankMaterialShell"
          $DRY_RUN_CMD cp -L "$DEFAULT_FILE" "$SETTINGS_FILE"
          echo "Created DMS settings.json from settings-default.json"
        fi
      fi
    '';
  };
}
