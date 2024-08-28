{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.steam;
in {
  options.my.steam = {
    enable = mkEnableOption (mdDoc "steam");
  };

  config = mkIf cfg.enable {
    # environment.systemPackages = [ pkgs.steam-run-native ];

    environment.systemPackages = with pkgs; [
      steamcmd
      xdg-user-dirs
    ];

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib
    ];

    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
    };

    # opengl.driSupport32Bit will become graphics.enable32Bit in the future
    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
    };

    hardware.steam-hardware.enable = true;
  };
}
