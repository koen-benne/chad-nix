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
        name = "microsoft-teams";
        greedy = true;
      }
      # Utility Tools
      {
        name = "1password";
        greedy = true;
      }
      {
        name = "focusrite-control";
        greedy = true;
      }
    ];
    masApps = {
      # Trello = 1278508951;
      # Xcode = 497799835;
    };
  };
}
