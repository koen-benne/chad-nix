{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.dankmaterialshell;
in {
  config = mkIf cfg.enable {
    # Enable gtklock-unwired for lockscreen
    my.gtklock-unwired.enable = true;
  };
}
