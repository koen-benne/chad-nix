{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.nix-helper;
in {

  options.my.nix-helper = {
    enable = mkEnableOption (mdDoc "nix-helper");
  };

  imports = [
    inputs.nh.overlays.default
  ];

  config = mkIf cfg.enable {
    # wait for https://github.com/LnL7/nix-darwin/pull/942
    # programs.nh = {
    #   enable = true;
    #   clean.enable = true;
    # };
    environment.systemPackages = with pkgs; [
      nh
    ];
  };
}
