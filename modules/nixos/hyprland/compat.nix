{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkForce;
  cfg = config.my.hyprland;
  hyprlandPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in {
  options.my.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    # In standalone home-manager mode there is no NixOS module to provide the
    # package, so we set it explicitly from the flake here.
    wayland.windowManager.hyprland.package = mkForce hyprlandPkgs.hyprland;

    # XDG desktop portal for standalone home-manager mode
    xdg.portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
      ];
      config.common.default = "*";
    };

    # Hyprland-specific packages for standalone mode
    home.packages = [
      pkgs.hyprpolkitagent
      pkgs.grim
      pkgs.slurp
    ];
  };
}
