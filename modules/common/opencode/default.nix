{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf genAttrs types;
  cfg = config.my.opencode;
in {
  options.my.opencode = {
    enable = mkEnableOption "opencode";

    bonzaiProfiles = mkOption {
      type = types.nonEmptyListOf types.str;
      default = ["knmi" "stayokay" "zadkine"];
    };
  };

  config = mkIf cfg.enable {
    # Create the API key files with sops, one per Bonzai profile
  sops.secrets = genAttrs
    (map (profile: "bonzai_api_key/${profile}") cfg.bonzaiProfiles)
    (name: {
      key = name;
      mode = "0400";
      owner = config.my.user;
    });
  };
}
