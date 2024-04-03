{ config, lib, pkgs, ... }:

let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.steam;
in
{
  options.my.steam = {
    enable = mkEnableOption (mdDoc "steam");
  };

  config = mkIf cfg.enable {

    # environment.systemPackages = [ pkgs.steam-run-native ];

    environment.systemPackages = with pkgs; [
      steamcmd
    ];

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib
    ];

    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
    };

    hardware.opengl = {
      enable = true;
      driSupport32Bit = true;
    };

    hardware.steam-hardware.enable = true;
  };
}
