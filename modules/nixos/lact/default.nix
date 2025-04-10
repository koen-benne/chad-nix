{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.corectrl;
in {
  options.my.corectrl = {
    enable = mkEnableOption (mdDoc "Enable CoreCtrl");
  };
  config = mkIf cfg.enable {
    programs.corectrl = {
      enable = true;
      gpuOverclock = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
    };
    boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];

    # Add polkit rules for corectrl
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if ((action.id == "org.corectrl.helper.init" ||
          action.id == "org.corectrl.helperkiller.init") &&
          subject.local == true &&
          subject.active == true &&
          subject.isInGroup("koenbenne")) {
            return polkit.Result.YES;
        }
      });
    '';
  };
}
