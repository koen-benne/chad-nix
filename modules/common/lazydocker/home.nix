{
  config,
  lib,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.lazydocker;
in {
  options.my.lazydocker = {
    enable = mkEnableOption (mdDoc "lazydocker");
  };
  config = mkIf cfg.enable {
    programs.lazydocker = {
      enable = true;
    };
  };
}
