{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.my.hyprland = {
    enable = mkEnableOption "hyprland";
    nixgl = {
      variant = mkOption {
        type = types.enum ["auto" "intel" "nvidia" "mesa"];
        default = "intel";
        description = "Which NixGL variant to use for standalone home-manager. Intel variant avoids nvidia impurities.";
      };
    };
  };
}