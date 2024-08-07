{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.nibar;
in {
  options.my.nibar = {
    enable = mkEnableOption (mdDoc "nibar");
  };

  config = mkIf cfg.enable {
    hm.my.nibar.enable = true;

    homebrew.casks = ["ubersicht"];
    services.yabai.config.external_bar = "main:24:0";
    system.defaults.NSGlobalDomain._HIHideMenuBar = true;
  };
}
