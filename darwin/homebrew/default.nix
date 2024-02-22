{ config, lib, pkgs, ... }:

{
  environment.systemPath = [ "/opt/homebrew/bin" ];
  environment.variables = { HOMEBREW_NO_ANALYTICS = "1"; };
  homebrew = {
    enable = true;
    # mutableTaps = false;
    # autoMigrate = true;
    onActivation = {
      # autoUpdate = true;
      cleanup = "zap";
    };
    global = {
      brewfile = true;
    };
    taps = [
      "homebrew/core"
      "homebrew/cask"
      # "homebrew/bundle"
      # "homebrew/homebrew-services"
    ];
    brews = [
      "mas"
    ];
    casks = [
      # Development Tools
      "homebrew/cask/docker"
      "lando"

      # Communication Tools
      "discord"
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
      Focalboard = 1556908618;
    };
    extraConfig = ''
      #
    '';
  };
}
