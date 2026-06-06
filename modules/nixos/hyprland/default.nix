{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.hyprland;
  hyprlandPkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in {
  options.my.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      hyprpolkitagent
    ];

    programs.hyprland = {
      enable = true;
      package = hyprlandPkgs.hyprland;
      portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };
  };
}
