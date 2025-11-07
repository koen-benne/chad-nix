{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.sys.my.desktop = {
    enable = mkEnableOption "desktop";
    windowManager = mkOption {
      type = types.enum ["aerospace" "none"];
      default = "none";
      description = "Window manager to use";
    };
    entries = mkOption {
      type = types.listOf types.attrs;
      default = [];
      description = "Desktop entries for dock/launcher";
    };
  };
}