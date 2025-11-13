{
  inputs,
  config,
  lib,
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
      systemd.enable = true;

      # All features enabled by default, but can be overridden
      enableSystemMonitoring = lib.mkDefault true;
      enableClipboard = lib.mkDefault true;
      enableVPN = lib.mkDefault true;
      enableBrightnessControl = lib.mkDefault true;
      enableColorPicker = lib.mkDefault true;
      enableDynamicTheming = lib.mkDefault true;
      enableAudioWavelength = lib.mkDefault true;
      enableCalendarEvents = lib.mkDefault true;
      enableSystemSound = lib.mkDefault true;
    };
  };
}
