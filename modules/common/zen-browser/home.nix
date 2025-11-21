{
  inputs,
  lib,
  sys,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = sys.my.zen-browser;
in {
  options.my.zen-browser = {
    enable = mkEnableOption (mdDoc "zen-browser");
  };

  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  config = mkIf cfg.enable {
    programs.zen-browser.enable = true;
  };
}
