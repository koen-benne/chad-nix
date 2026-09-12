{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption genAttrs types;
  cfg = config.my.opencode;
in {
  options.my.opencode = {
    enable = mkEnableOption "opencode";

    bonzaiProfiles = mkOption {
      type = types.nonEmptyListOf types.str;
      default = ["knmi" "stayokay" "zadkine"];
    };
  };

  # config.sops.secrets = genAttrs cfg.bonzaiProfiles (profile: {
  #     key = "bonzai_api_key/${profile}";
  #     mode = "0400";
  #   });

  config.sops.secrets = genAttrs
    (map (profile: "bonzai_api_key/${profile}") cfg.bonzaiProfiles)
    (name: {
      key = name;
      mode = "0400";
    });
}
