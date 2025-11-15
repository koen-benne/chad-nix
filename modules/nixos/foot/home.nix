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
      server.enable = true;
    };
    
    # Add shell aliases for easy access
    programs.fish.shellAliases = mkIf config.programs.fish.enable {
      foot = footCommand;
      footc = footServerCommand;
    };
    
    programs.zsh.shellAliases = mkIf config.programs.zsh.enable {
      foot = footCommand;
      footc = footServerCommand;
    };
  };
}
