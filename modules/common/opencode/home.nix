{
  sys,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf sys.my.opencode.enable {
    home.packages = [
      pkgs.unstable.opencode
    ];

    xdg.configFile = {
      "opencode/opencode.json" = {
        text =
          lib.replaceStrings
          ["__BONZAI_SECRET_PATH__" "\"nil\""]
          [sys.sops.secrets.bonzai_api_key.path "\"${pkgs.nil}/bin/nil\""]
          (builtins.readFile ./opencode.json);
      };
      "opencode/plugin/bonzai-remove-unsupported-params.ts" = {
        source = ./bonzai-remove-unsupported-params.ts;
      };
    };
  };
}
