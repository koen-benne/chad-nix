# All darwin systems will have these packages
{
  config,
  lib,
  pkgs,
  ...
}: {
  homebrew = {
    casks = [
      # Utility Tools
      "appcleaner"
      "onyx"

      # Browsers
      "arc"
    ];
    masApps = {
      # Trello = 1278508951;
      # Xcode = 497799835;
    };
  };
}
