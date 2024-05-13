{ config, lib, pkgs, ... }:
# Configured with help of https://github.com/dwarfmaster/arkenfox-nixos

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

      arkenfox = {
        enable = true;
        version = "122.0";
      };

      profiles = {
        default = {
          arkenfox = {
            enable = true;
          };
          isDefault = true;
          name = "default";
          userChrome = uc;
        };
      };
    };

  };
}

