{ config, lib, pkgs, ... }:

{
  homebrew = {
    enable = true;
    onActivation = {
      # autoUpdate = true;
      cleanup = "zap";
    };
    taps = [
    ];
    brews = [
      "mas"
    ];
    casks = [
      # Development Tools
      "homebrew/cask/docker"
      "lando"
      "android-studio"

      # Communication Tools
      "slack"

      # Utility Tools
      "appcleaner"
      "1password"
      "onyx"

      # Browsers
      "brave-browser"
      "firefox"

       # Design Tools
       "figma"
    ];
    masApps = {
      Trello = 1278508951;
      # Xcode = 497799835;
    };
  };
}
