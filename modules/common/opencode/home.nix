{
  sys,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf sys.my.opencode.enable {
    home.packages = [
      pkgs.unstable.opencode
      pkgs.jq
    ];

    programs.fish.shellAliases.oc = "opencode";

    programs.fish.functions.os = {
      description = "Open an opencode session picked with fzf";
      body = ''
        set data (opencode session list --format json | jq -r '.[] | "\(.id)\t\(.title // "untitled")"')
        set title (printf '%s\n' $data | cut -f2 | fzf)
        if test -z "$title"
          return
        end
        set session (printf '%s\n' $data | awk -F'\t' -v t="$title" '$2 == t {print $1; exit}')
        if test -n "$session"
          opencode --session $session
        end
      '';
    };

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
