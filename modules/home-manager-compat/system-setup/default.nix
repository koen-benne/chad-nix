{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.system-setup;

  # Helper function to check if a command exists and is working
  checkComponent = name: component: ''
    check_${lib.replaceStrings ["-"] ["_"] name}() {
      echo "[>] ${component.name}"
      echo "     ${component.description}"
      echo ""
      echo "  [i] Setup instructions:"

      # Detect distro and show appropriate instructions
      if command -v apt >/dev/null 2>&1; then
        distro="ubuntu"
      elif command -v dnf >/dev/null 2>&1; then
        distro="fedora"
      elif command -v pacman >/dev/null 2>&1; then
        distro="arch"
      else
        distro="generic"
      fi

      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (d: instructions: ''
        if [[ "$distro" == "${d}" ]]; then
          ${lib.concatMapStringsSep "\n" (instr: ''echo "     ${instr}"'') instructions}
        fi
      '')
      component.setupInstructions)}

      echo ""
      return 0
    }
    check_${lib.replaceStrings ["-"] ["_"] name}
  '';

  # Priority icons using ASCII symbols
  getPriorityIcon = priority:
    {
      critical = "[!]"; # Critical priority
      recommended = "[i]"; # Info/recommended
      optional = "[?]"; # Optional
    }.${
      priority
    };

  # Sort components by priority
  sortedComponents = lib.sort (
    a: b: let
      priorities = {
        critical = 0;
        recommended = 1;
        optional = 2;
      };
    in
      priorities.${a.value.priority} < priorities.${b.value.priority}
  ) (lib.mapAttrsToList lib.nameValuePair cfg.checks);
in {
  # System setup helper for home-manager standalone mode
  # Provides setup instructions for system-level requirements
  # that home-manager can't configure automatically

  options.my.system-setup = {
    enable = lib.mkEnableOption "system setup helper instructions";

    checks = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Human-readable name for this system component";
          };

          description = lib.mkOption {
            type = lib.types.str;
            description = "What this component does";
          };

          checkCommands = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Commands to check if the component is properly set up";
          };

          setupInstructions = lib.mkOption {
            type = lib.types.attrsOf (lib.types.listOf lib.types.str);
            description = "Setup instructions per distro";
          };

          priority = lib.mkOption {
            type = lib.types.enum ["critical" "recommended" "optional"];
            default = "recommended";
            description = "How important this setup is";
          };
        };
      });
      default = {};
      description = "System components to check and provide setup instructions for";
    };
  };

  config = mkIf (cfg.enable && config.my.isStandalone) {
    home.activation.systemSetupHelper = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo ""
      echo "[*] System Setup Helper - Checking system requirements..."
      echo "=================================================="
      echo ""

      totalComponents=${toString (lib.length sortedComponents)}

      ${lib.concatMapStringsSep "\n\n" (comp: ''
          ${checkComponent comp.name comp.value}
        '')
        sortedComponents}

      echo ""
      echo "=================================================="
      echo "[i] Setup instructions for $totalComponents system components shown above"
      echo ""
      echo "Legend:"
      echo "  [!] Critical - Required for basic functionality"
      echo "  [i] Recommended - Improves experience significantly"
      echo "  [?] Optional - Nice to have features"
      echo ""
    '';
  };
}
