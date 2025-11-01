# System-manager compatible home-manager module
# Adapted from nixos home-manager module but without systemd.user dependencies
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.home-manager;

  # Extended lib for home-manager
  extendedLib = import "${inputs.home-manager}/modules/lib/stdlib-extended.nix" lib;

  # Home Manager module type
  hmModule = lib.types.submoduleWith {
    description = "Home Manager module";
    class = "homeManager";
    specialArgs = {
      lib = extendedLib;
      osConfig = config;
      modulesPath = builtins.toString "${inputs.home-manager}/modules";
    } // cfg.extraSpecialArgs;
    modules = [
      ({ name, ... }: {
        imports = import "${inputs.home-manager}/modules/modules.nix" {
          inherit pkgs;
          lib = extendedLib;
          useNixpkgsModule = !cfg.useGlobalPkgs;
        };

        config = {
          submoduleSupport.enable = true;
          submoduleSupport.externalPackageInstall = cfg.useUserPackages;
          
          # Set username and home directory manually since we don't have users.users
          home.username = name;
          home.homeDirectory = "/home/${name}";
          
          # Use system nix package
          nix.package = pkgs.nix;
          nix.enable = true;
        };
      })
    ] ++ cfg.sharedModules;
  };

  serviceEnvironment = 
    lib.optionalAttrs (cfg.backupFileExtension != null) {
      HOME_MANAGER_BACKUP_EXT = cfg.backupFileExtension;
    }
    // lib.optionalAttrs cfg.verbose { VERBOSE = "1"; };

in
{
  options.home-manager = {
    useUserPackages = lib.mkEnableOption ''
      installation of user packages through the system packages'';

    useGlobalPkgs = lib.mkEnableOption ''
      using the system configuration's `pkgs` argument in Home Manager'';

    backupFileExtension = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "backup";
      description = ''
        On activation move existing files by appending the given
        file extension rather than exiting with an error.
      '';
    };

    extraSpecialArgs = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      example = lib.literalExpression "{ inherit emacs-overlay; }";
      description = ''
        Extra `specialArgs` passed to Home Manager.
      '';
    };

    sharedModules = lib.mkOption {
      type = with lib.types; listOf raw;
      default = [];
      example = lib.literalExpression "[ { home.packages = [ nixpkgs-fmt ]; } ]";
      description = ''
        Extra modules added to all users.
      '';
    };

    verbose = lib.mkEnableOption "verbose output on activation";

    users = lib.mkOption {
      type = lib.types.attrsOf hmModule;
      default = {};
      description = ''
        Per-user Home Manager configuration.
      '';
    };
  };

  config = lib.mkIf (cfg.users != {}) {
    # Install home-manager system-wide
    environment.systemPackages = [ pkgs.home-manager ];

    # Create systemd services for automatic home-manager activation
    systemd.services = lib.mapAttrs' (username: usercfg:
      lib.nameValuePair "home-manager-${username}" {
        description = "Home Manager environment for ${username}";
        wantedBy = [ "multi-user.target" ];
        wants = [ "nix-daemon.socket" ];
        after = [ "nix-daemon.socket" ];
        
        environment = serviceEnvironment;

        unitConfig = {
          RequiresMountsFor = "/home/${username}";
        };

        stopIfChanged = false;

        serviceConfig = {
          User = username;
          Type = "oneshot";
          TimeoutStartSec = "5m";
          SyslogIdentifier = "hm-activate-${username}";
          
          # Set up environment variables
          Environment = [
            "HOME=/home/${username}"
            "USER=${username}"
          ];

          ExecStart = let
            setupEnv = pkgs.writeScript "hm-setup-env-${username}" ''
              #!/bin/sh
              # Simple environment setup for system-manager
              export HOME="/home/${username}"
              export USER="${username}"
              export PATH="${pkgs.coreutils}/bin:${pkgs.nix}/bin:$PATH"
              
              ${lib.optionalString cfg.verbose "export VERBOSE=1"}
              ${lib.optionalString (cfg.backupFileExtension != null) 
                "export HOME_MANAGER_BACKUP_EXT=${cfg.backupFileExtension}"}
              
              exec "${usercfg.home.activationPackage}/activate"
            '';
          in "${setupEnv}";
        };
      }
    ) cfg.users;

    # Add user packages to system packages if enabled
    environment.systemPackages = lib.mkIf cfg.useUserPackages (
      lib.flatten (lib.mapAttrsToList (_: usercfg: usercfg.home.packages) cfg.users)
    );

    # Propagate warnings and assertions
    warnings = lib.flatten (
      lib.mapAttrsToList (user: config: 
        map (warning: "${user} profile: ${warning}") config.warnings
      ) cfg.users
    );

    assertions = lib.flatten (
      lib.mapAttrsToList (user: config:
        map (assertion: {
          inherit (assertion) assertion;
          message = "${user} profile: ${assertion.message}";
        }) config.assertions
      ) cfg.users
    );
  };
}