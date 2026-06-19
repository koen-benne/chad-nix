{
  config,
  lib,
  pkgs,
  sys,
  ...
}: let
  inherit (lib) mkIf optional;
  cfg = sys.my.work;
in {
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

    programs.git = {
      includes = [
        {
          contents.user.email = config.my.workmail;
          condition = "gitdir:~/work/";
        }
      ];
      settings.credential."https://bitbucket.org/mangrove/" = {
        helper = "!f() { echo username=x-bitbucket-api-token-auth; echo password=$(cat ${sys.sops.secrets.bitbucket_api_token.path}); }; f";
      };
    };
  };
}
