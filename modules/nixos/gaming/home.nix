{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.gaming;
in {
  options.my.gaming = {
    enable = mkEnableOption (mdDoc "gaming");
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # MC shit
      prismlauncher
      unstable.vintagestory
      jdk8
    ];
  };
}
