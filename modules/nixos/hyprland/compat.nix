{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.my.hyprland = {
    enable = mkEnableOption "hyprland";
    nixgl = {
      variant = mkOption {
        type = types.enum ["auto" "intel" "nvidia" "mesa"];
        default = "auto";
        description = "Which NixGL variant to use for standalone home-manager. Auto-detection attempts Intel first.";
      };
    };
  };
}