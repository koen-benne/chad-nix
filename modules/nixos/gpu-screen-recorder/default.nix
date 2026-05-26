{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.gpu-screen-recorder;
in {
  options.my.gpu-screen-recorder = {
    enable = mkEnableOption (mdDoc "gpu-screen-recorder");
  };

  config = mkIf cfg.enable {
    security.wrappers.gsr-global-hotkeys = {
      owner = "root";
      group = "root";
      capabilities = "cap_setuid+ep";
      source = "${pkgs.gpu-screen-recorder-ui}/bin/gsr-global-hotkeys";
    };
  };
}
