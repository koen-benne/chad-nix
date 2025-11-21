{
  inputs,
  lib,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  cfg = sys.my.zen-browser;
in {
  imports = [
    inputs.zen-browser.homeModules.beta
  ];

  config = mkIf cfg.enable {
    programs.zen-browser.enable = true;
  };
}
