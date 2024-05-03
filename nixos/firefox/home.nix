{ config, lib, pkgs, ... }:

let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.firefox;
  uc = builtins.readFile ./userChrome.css;

in
{
  options.my.firefox = {
    enable = mkEnableOption (mdDoc "firefox");
  };

  config = mkIf cfg.enable {

    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          isDefault = true;
          name = "default";
          userChrome = uc;
        };
      };
    };

  };
}
