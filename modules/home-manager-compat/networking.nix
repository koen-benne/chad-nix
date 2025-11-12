{lib, ...}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.networking = {
    networkmanager = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether NetworkManager is enabled";
      };
    };
  };
}