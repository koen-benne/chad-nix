{
  sys,
  lib,
  pkgs,
  ...
}: let
  bonzaiProfiles = sys.my.opencode.bonzaiProfiles;
  defaultBonzaiProfile = lib.head bonzaiProfiles;

  bonzaiProfileCases =
    lib.concatMapStringsSep "\n" (profile: ''
      ${profile}) key_file=${sys.sops.secrets."bonzai_api_key/${profile}".path} ;;
    '')
    bonzaiProfiles;

  # Wraps opencode so BONZAI_API_KEY_PROFILE picks which sops-managed
  # Bonzai API key gets exported as BONZAI_API_KEY. Defaults to the first
  # entry in `my.opencode.bonzaiProfiles`. Set BONZAI_API_KEY_PROFILE via
  # direnv/devenv per project to switch.
  opencode-wrapped = pkgs.writeShellScriptBin "opencode" ''
    set -euo pipefail

    profile="''${BONZAI_API_KEY_PROFILE:-${defaultBonzaiProfile}}"

    case "$profile" in
      ${bonzaiProfileCases}
      *)
        echo "opencode: unknown BONZAI_API_KEY_PROFILE '$profile' (expected one of: ${lib.concatStringsSep ", " bonzaiProfiles})" >&2
        exit 1
        ;;
    esac

    export BONZAI_API_KEY="$(cat "$key_file")"
    exec ${pkgs.unstable.opencode}/bin/opencode "$@"
  '';
in {
  config = lib.mkIf sys.my.opencode.enable {
    home.packages = [
      opencode-wrapped
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
          ["\"nil\""]
          ["\"${pkgs.nil}/bin/nil\""]
          (builtins.readFile ./opencode.json);
      };
      "opencode/plugin/bonzai-remove-unsupported-params.ts" = {
        source = ./bonzai-remove-unsupported-params.ts;
      };
      "opencode/skills/spec-tree/SKILL.md" = {
        source = ./skills/spec-tree/SKILL.md;
      };
      "opencode/skills/hunk-review/SKILL.md" = {
        source = "${pkgs.unstable.hunk}/skills/hunk-review/SKILL.md";
      };
    };
  };
}
