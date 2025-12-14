{
  config,
  pkgs,
  lib,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  cfg = sys.my.gaming;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      unstable.lutris
      # MC shit
      unstable.vintagestory

      (prismlauncher.override {
        # Add binary required by some mod
        additionalPrograms = [ ffmpeg ];

        # Change Java runtimes available to Prism Launcher
        jdks = [
          graalvm-ce
          zulu8
          zulu17
          zulu
        ];
      })
    ];
  };
}
