{
  config,
  lib,
  pkgs,
  sys,
  ...
}: let
  inherit (lib) mkEnableOption mkIf optional;
  cfg = config.my.work;
in {
  options.my.work = {
    enable = mkEnableOption "work";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # globalprotect-openconnect
      teams-for-linux
      slack

      unstable.tableplus

      notesnook
      obsidian
    ];

    programs.khal = {
      enable = true;
      locale = {
        timeformat = "%H:%M";
        dateformat = "%d/%m/%Y";
        longdateformat = "%d/%m/%Y";
        datetimeformat = "%d/%m/%Y %H:%M";
        longdatetimeformat = "%d/%m/%Y %H:%M";
        firstweekday = 0;
      };
    };

    accounts.calendar = {
      basePath = "${config.home.homeDirectory}/.local/share/khal/calendars";
      accounts = {
        private = {
          primary = true;
          khal = {
            enable = true;
            color = "light green";
          };
        };
        work = {
          khal = {
            enable = true;
            color = "light cyan";
            type = "discover";
            addresses = [config.my.workmail];
          };
        };
      };
    };
  };
}
