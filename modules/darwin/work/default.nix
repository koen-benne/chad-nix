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
        {
          name = "homebrew/cask/docker";
          greedy = true;
        }
        "lando"
        "sequel-ace"

        # Communication Tools
        # "slack"
        # "microsoft-teams"

        # Utility Tools
        {
          name = "1password";
          greedy = true;
        }

        # Design Tools
        # "figma"
      ];
    };
  };
}
