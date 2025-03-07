{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.lact;
in {
  options.my.lact = {
    enable = mkEnableOption (mdDoc "Enable LACT");
  };
  config = mkIf cfg.enable {
    services.lact.enable = true;
  };
}
