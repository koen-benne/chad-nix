{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.foot;
  
  # Different commands based on whether we're in standalone mode
  footCommand = if config.my.isStandalone 
    then "${inputs.nixgl.packages.${pkgs.system}.nixGLIntel}/bin/nixGL foot"
    else "foot";
    
  footServerCommand = if config.my.isStandalone
    then "${inputs.nixgl.packages.${pkgs.system}.nixGLIntel}/bin/nixGL foot --server"
    else "foot --server";
in {
  options.my.foot = {
    enable = mkEnableOption (mdDoc "foot");
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      settings.main = {
        pad = "0x0 center";
      };
    };
  };
}
