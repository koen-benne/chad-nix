{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.nixgl-desktop;

  # Get the appropriate nixGL package based on variant
  getNixGLPackage = variant:
    if variant == "auto" then
      inputs.nixgl.packages.${pkgs.system}.nixGLDefault
    else
      inputs.nixgl.packages.${pkgs.system}.${variant};

  # Create a desktop entry for an application with nixGL wrapper
  makeNixGLDesktopEntry = name: app: {
    name = "${name}-nixgl";
    value = {
      name = app.name;
      exec =
        if app.nixGLVariant == "auto" then
          "nixGL ${app.exec}"
        else
          "${getNixGLPackage app.nixGLVariant}/bin/${app.nixGLVariant} ${app.exec}";
      icon = app.icon;
      comment = app.comment;
      categories = app.categories;
      mimeType = app.mimeType;
      type = "Application";
      terminal = false;
    };
  };

in {
  # nixGL desktop entries for home-manager standalone mode
  # This provides custom desktop files that wrap applications with nixGL
  # for proper graphics acceleration on non-NixOS systems

  options.my.nixgl-desktop = {
    enable = lib.mkEnableOption "nixGL-wrapped desktop entries";

    applications = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            description = "Display name for the application";
          };

          exec = lib.mkOption {
            type = lib.types.str;
            description = "Command to execute (will be wrapped with nixGL)";
          };

          icon = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Icon name or path";
          };

          categories = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = ["Application"];
            description = "Desktop entry categories";
          };

          comment = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Comment/description for the application";
          };

          mimeType = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "MIME types this application can handle";
          };

          nixGLVariant = lib.mkOption {
            type = lib.types.enum ["auto" "nixGLIntel" "nixGLNvidia" "nixGLMesa"];
            default = "auto";
            description = "Which nixGL variant to use";
          };
        };
      });
      default = {};
      description = "Applications to create nixGL-wrapped desktop entries for";
    };
  };

  config = mkIf (cfg.enable && config.my.isStandalone) {
    xdg.desktopEntries = lib.listToAttrs (
      lib.mapAttrsToList makeNixGLDesktopEntry cfg.applications
    );
    
    # Add a test entry to verify the module is working
    home.activation.nixglDesktopTest = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [[ ${toString (lib.length (lib.attrNames cfg.applications))} -gt 0 ]]; then
        echo "[*] Created ${toString (lib.length (lib.attrNames cfg.applications))} nixGL desktop entries"
      fi
    '';
  };
}
