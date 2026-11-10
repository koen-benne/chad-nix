{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.lazydocker;
in {
  options.my.lazydocker = {
    enable = mkEnableOption "lazydocker";
  };
  config = mkIf cfg.enable {
    programs.lazydocker = {
      enable = true;
    };
  };
}
