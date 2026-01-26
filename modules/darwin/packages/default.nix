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
      {
        name = "zen";
        greedy = true;
      }

      {
        name = "spotify";
        greedy = true;
      }

      {
        name = "focusrite-control";
        greedy = true;
      }
    ];
  };
}
