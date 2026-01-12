{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption mkEnableOption types;
  cfg = config.my.gtklock-unwired;
in {
  options.my.gtklock-unwired = {
    enable = mkEnableOption (lib.mdDoc "gtklock-unwired lockscreen (based on unwiredfromreality's config)");

    lockCommand = mkOption {
      type = types.str;
      default = "${config.xdg.configHome}/gtklock-unwired/lock.sh";
      description = lib.mdDoc "Command to execute when locking the screen with gtklock-unwired";
    };

    suspendCommand = mkOption {
      type = types.str;
      default = "${config.xdg.configHome}/gtklock-unwired/lock-and-suspend.sh";
      description = lib.mdDoc "Command to execute when suspending (locks first, then suspends)";
    };

    wallpaper = mkOption {
      type = types.path;
      default = ../../../assets/wp-normal.jpg;
      description = lib.mdDoc "Wallpaper to use for the lockscreen background";
    };

    fontFace = mkOption {
      type = types.str;
      default = "Libre Baskerville";
      description = lib.mdDoc "Font face for the clock display";
    };

    fontColor = mkOption {
      type = types.str;
      default = "#f2e5bc";
      description = lib.mdDoc "Font color for the clock display";
    };

    backgroundColor = mkOption {
      type = types.str;
      default = "#f2e5bc";
      description = lib.mdDoc "Background color for playerctl module";
    };

    modules = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        gtklock-playerctl-module
      ];
      description = lib.mdDoc "Gtklock modules to enable (playerctl, userinfo, powerbar, etc.)";
    };
  };

  config = mkIf cfg.enable {
    # Note: gtklock itself is installed via apt, not Nix
    # Only install gtklock modules from Nix
    home.packages = cfg.modules;

    # Create styles.css based on unwiredfromreality's config
    xdg.configFile."gtklock-unwired/styles.css".text = ''
      * {
        box-shadow: none;
      }

      window {
        background-size: cover;
        background-repeat: no-repeat;
        background-position: center;
      }

      #playerctl-revealer > box {
        background-color: ${cfg.backgroundColor};
        border-radius: 4px;
        padding: 1em;
        margin-bottom: 4em;
      }

      #clock-label {
        font-size: 0;
      }

      /* hide "Password:" label */
      #input-label {
        font-size: 0;
      }

      #input-field {
      }

      #window-box {
        margin-top: 54em;
      }
    '';

    # Create lock script using gtklock command line options
    xdg.configFile."gtklock-unwired/lock.sh" = {
      text = let
        modulePaths = builtins.map (pkg: "${pkg}/lib/gtklock/${pkg.pname}.so") cfg.modules;
        moduleArgs = lib.concatMapStringsSep " " (m: "-m ${m}") modulePaths;
      in ''
        #!/usr/bin/env bash
        /usr/bin/gtklock \
          -b ${cfg.wallpaper} \
          -s ${config.xdg.configHome}/gtklock-unwired/styles.css \
          ${moduleArgs}
      '';
      executable = true;
    };

    # Create lock-and-suspend script
    xdg.configFile."gtklock-unwired/lock-and-suspend.sh" = {
      text = ''
        #!/usr/bin/env bash
        ${cfg.lockCommand} &
        sleep 1
        systemctl suspend
      '';
      executable = true;
    };

    # If dankmaterialshell is enabled, override its lock and suspend commands
    programs.dank-material-shell.settings = lib.mkIf config.my.dankmaterialshell.enable {
      customPowerActionLock = cfg.lockCommand;
      customPowerActionSuspend = cfg.suspendCommand;
    };
  };
}
