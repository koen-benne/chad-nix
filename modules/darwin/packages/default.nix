# All darwin systems will have these packages
{
  config,
  lib,
  pkgs,
  ...
}: {
  homebrew = {
    brews = [
      "choose-gui"
    ];
    casks = [
      # Utility Tools
      "appcleaner"
      "onyx"

      # Browsers
      # "arc"
      "steam"
      {
        name = "zen";
        greedy = true;
      }
      {
        name = "google-chrome";
        greedy = true;
      }
      {
        name = "microsoft-teams";
        greedy = true;
      }
      {
        name = "slack";
        greedy = true;
      }
    ];
    masApps = {
      # Trello = 1278508951;
      # Xcode = 497799835;
    };
  };
}
