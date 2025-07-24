{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mdDoc;
  cfg = config.my.work;
in {
  options.my.work = {
    enable = mkEnableOption (mdDoc "work");
  };

  config = mkIf cfg.enable {
    homebrew = {
      casks = [
        # Development Tools
        "sequel-ace"

        # Communication Tools
        # "microsoft-teams"
        {
          name = "slack";
          greedy = true;
        }

        {
          name = "google-chrome";
          greedy = true;
        }

        # Design Tools
        # "figma"
      ];
    };
  };
}
