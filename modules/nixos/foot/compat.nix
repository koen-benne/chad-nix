{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  config = mkIf config.my.foot.enable {
    # Enable nixGL-wrapped desktop entry for foot terminal
    my.nixgl-desktop.enable = true;
    my.nixgl-desktop.applications.foot = {
      name = "Foot Terminal";
      exec = "foot";
      icon = "utilities-terminal";
      categories = ["System" "TerminalEmulator"];
      comment = "Fast, lightweight terminal emulator";
    };
  };
}
