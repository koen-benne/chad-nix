{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.gaming;
in {
  options.my.gaming = {
    enable = mkEnableOption (mdDoc "gaming");
    enableSunshine = mkEnableOption (mdDoc "sunshine");
  };

  config = mkIf cfg.enable {
    # environment.systemPackages = [ pkgs.steam-run-native ];

    environment.systemPackages = with pkgs; [
      steamcmd
      xdg-user-dirs
      protonup-qt
    ];

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc.lib
    ];

    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    hardware.steam-hardware.enable = true;

    services.sunshine = mkIf cfg.enableSunshine {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
