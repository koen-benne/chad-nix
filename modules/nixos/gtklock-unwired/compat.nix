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
        font-family: "${cfg.fontFace}";
        font-size: 72pt;
        font-weight: 700;
        color: #ffffff;
        text-shadow: 0 4px 12px rgba(0, 0, 0, 0.5),
                     0 2px 4px rgba(0, 0, 0, 0.3);
      }

      #date-label {
        text-shadow: 0 2px 6px rgba(0, 0, 0, 0.4),
                     0 1px 2px rgba(0, 0, 0, 0.2);
      }

      /* hide "Password:" label */
      #input-label {
        font-size: 0;
      }

      /* Glass morphism unlock button */
      #unlock-button {
        background: rgba(255, 255, 255, 0.15);
        border: 1px solid rgba(255, 255, 255, 0.3);
        border-radius: 8px;
        color: #ffffff;
        padding: 6px 12px;
        min-height: 28px;
        min-width: 60px;
        font-size: 13px;
        font-weight: 600;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3),
                    inset 0 1px 0 rgba(255, 255, 255, 0.2);
        transition-property: all;
        transition-duration: 200ms;
      }

      #unlock-button:hover {
        background: rgba(255, 255, 255, 0.25);
        border-color: rgba(255, 255, 255, 0.4);
        box-shadow: 0 12px 40px rgba(0, 0, 0, 0.4),
                    inset 0 1px 0 rgba(255, 255, 255, 0.3);
      }

      #unlock-button:active {
        background: rgba(255, 255, 255, 0.2);
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3),
                    inset 0 1px 0 rgba(255, 255, 255, 0.1);
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
