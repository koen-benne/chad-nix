{
  config,
  inputs,
  ...
}: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    taps = [
    ];
    brews = [
      "mas"
    ];
  };

  nix-homebrew = {
    enable = true;
    user = config.my.user;
    enableRosetta = true;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
    };
    mutableTaps = false;
    autoMigrate = true;
    enableFishIntegration = true;
  };
}
