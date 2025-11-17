{lib, ...}: let
  inherit (lib) mkEnableOption;
in {
  options.my.opencode = {
    enable = mkEnableOption "opencode";
  };

  sops.secrets.bonzai_api_key = {
    mode = "0400";
  };
}
