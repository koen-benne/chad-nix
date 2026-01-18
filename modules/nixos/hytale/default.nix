{ config, lib, inputs, ... }:
let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.hytale;
in {
  imports = [
    inputs.nix-hytale-server.nixosModules.hytale-server
  ];

  options.my.hytale = {
    enable = mkEnableOption (mdDoc "Hytale dedicated server");
  };

  config = mkIf cfg.enable {
    services.hytale-server = {
      enable = true;
      openFirewall = true;
      useRecommendedJvmOpts = true;
      # serverPort = 5502; # upstream default
    };
  };
}
