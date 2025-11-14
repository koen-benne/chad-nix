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
    programs.dankMaterialShell = {
      enable = true;
      systemd.enable = true;

      # All features enabled by default, but can be overridden
      enableSystemMonitoring = lib.mkDefault true;
      enableClipboard = lib.mkDefault true;
      # enableVPN = lib.mkDefault true;
      enableBrightnessControl = lib.mkDefault true;
      # enableColorPicker = lib.mkDefault true;
      # enableDynamicTheming = lib.mkDefault true;
      enableAudioWavelength = lib.mkDefault true;
      enableCalendarEvents = lib.mkDefault true;
      enableSystemSound = lib.mkDefault true;
    };
  };
}
