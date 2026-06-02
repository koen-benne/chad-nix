{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.my.corectrl;
in {
  options.my.corectrl = {
    enable = mkEnableOption "Enable CoreCtrl";
  };
  config = mkIf cfg.enable {
    programs.corectrl = {
      enable = true;
    };
    hardware.amdgpu.overdrive.enable = true;
    hardware.amdgpu.overdrive.ppfeaturemask = "0xffffffff";

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
