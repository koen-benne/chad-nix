{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.hyprland;
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
      package = pkgs.unstable.hyprland;
      xwayland.enable = true;
      withUWSM = true;
    };
  };
}
