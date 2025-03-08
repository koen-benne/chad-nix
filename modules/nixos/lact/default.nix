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
    environment.systemPackages = with pkgs; [ geekbench ];

    programs.corectrl = {
      enable = true;
      gpuOverclock = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
    };
    boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];
  };
}
