{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.sys.my.opencode = {
    enable = mkEnableOption "opencode";
  };

  # Provide empty sops structure for compatibility
  options.sys.sops.secrets = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = {};
    description = "Sops secrets placeholder for home-manager compatibility";
  };
}
