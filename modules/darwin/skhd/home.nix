{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.desktop;
in {
  config = mkIf (cfg.windowManager == "yabai") {
    home.activation.skhd = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${pkgs.skhd}/bin/skhd --reload || /usr/bin/killall skhd || true
    '';
  };
}
