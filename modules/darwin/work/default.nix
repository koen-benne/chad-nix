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
        "homebrew/cask/docker"
        "lando"
        "sequel-ace"

        # Communication Tools
        # "slack"
        # "microsoft-teams"

        # Utility Tools
        "1password"

        # Design Tools
        # "figma"
      ];
    };
  };
}
