{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.my.thunderbird;
in {
  options.my.thunderbird = {
    enable = mkEnableOption "thunderbird";
  };
  config = mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      profiles = {
        default = {
          isDefault = true;
        };
      };
    };
  };
}
