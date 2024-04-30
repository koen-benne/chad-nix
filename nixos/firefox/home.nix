{ config, lib, pkgs, ... }:

let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.firefox;
  uc = ./userChrome.css;

in
{
  options.my.firefoxj = {
    enable = mkEnableOption (mdDoc "firefox");
  };

  config = mkIf cfg.enable {

    programs.firefox = {
      enable = true;
      profiles = [
        {
          isDefault = true;
          name = "default";
          userChrome = uc;
        }
      ];
    };

  };
}
