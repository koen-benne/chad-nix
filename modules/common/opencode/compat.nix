{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.my.opencode = {
    enable = mkEnableOption "opencode";
  };

  # Provide empty sops structure for compatibility
  options.sops.secrets = mkOption {
    type = types.attrsOf (types.submodule {
      options = {
        path = mkOption {
          type = types.str;
          default = "/dev/null";
          description = "Mock path for home-manager compatibility";
        };
      };
    });
    default = {
      bonzai_api_key = {
        path = "/dev/null";
      };
    };
    description = "Sops secrets placeholder for home-manager compatibility";
  };
}