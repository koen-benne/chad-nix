{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.my.dankmaterialshell;
in {
  options.my.dankmaterialshell = {
    lockCommand = mkOption {
      type = types.str;
      default = "${config.xdg.configHome}/gtklock/lock.sh";
      description = lib.mdDoc "Command to execute when locking the screen";
    };

    suspendCommand = mkOption {
      type = types.str;
      default = "${config.xdg.configHome}/gtklock/lock-and-suspend.sh";
      description = lib.mdDoc "Command to execute when suspending (locks first, then suspends)";
    };
  };

  config = mkIf cfg.enable {
    # Create lock script
    xdg.configFile."gtklock/lock.sh" = {
      text = ''
        #!/usr/bin/env bash
        /usr/bin/gtklock -d -s ${config.xdg.configHome}/gtklock/style.css -b ${../../../assets/wp-normal.jpg}
      '';
      executable = true;
    };

    # Create lock-and-suspend script
    xdg.configFile."gtklock/lock-and-suspend.sh" = {
      text = ''
        #!/usr/bin/env bash
        ${config.xdg.configHome}/gtklock/lock.sh &
        sleep 1
        systemctl suspend
      '';
      executable = true;
    };

    # Configure gtklock appearance with CSS
    xdg.configFile."gtklock/style.css".text = let
      colors = config.lib.stylix.colors.withHashtag;
      fonts = config.stylix.fonts;
    in ''
      /* Gtklock enhanced styling with background overlay */

      /* Dark overlay for better contrast */
      #body {
        background-color: rgba(0, 0, 0, 0.7);
        margin: 0;
        padding: 60px;
      }

      /* Clock - large, bold, with shadow */
      #clock-label {
        font-family: "${fonts.sansSerif.name}";
        font-size: 120px;
        font-weight: 300;
        color: white;
        background-color: rgba(0, 0, 0, 0.8);
        padding: 20px 40px;
        border-radius: 16px;
        margin-bottom: 20px;
      }

      /* Date - elegant, spaced */
      #date-label {
        font-family: "${fonts.sansSerif.name}";
        font-size: 28px;
        font-weight: 300;
        color: white;
        letter-spacing: 2px;
        background-color: rgba(0, 0, 0, 0.8);
        padding: 12px 24px;
        border-radius: 12px;
        margin-bottom: 80px;
      }

      /* Input field - modern, glowing, frosted glass effect */
      #input-field {
        font-family: "${fonts.sansSerif.name}";
        font-size: 18px;
        background: linear-gradient(135deg, alpha(${colors.base02}, 0.8), alpha(${colors.base01}, 0.6));
        color: ${colors.base05};
        border: 2px solid alpha(${colors.base0D}, 0.6);
        border-radius: 12px;
        padding: 20px 24px;
        min-width: 400px;
        min-height: 60px;
        box-shadow: 0 8px 32px alpha(${colors.base00}, 0.6),
                    inset 0 1px 2px alpha(${colors.base07}, 0.15);
        transition: all 300ms cubic-bezier(0.4, 0, 0.2, 1);
      }

      #input-field:focus {
        border-color: ${colors.base0D};
        background: linear-gradient(135deg, alpha(${colors.base02}, 0.9), alpha(${colors.base01}, 0.7));
        box-shadow: 0 12px 48px alpha(${colors.base0D}, 0.4),
                    0 0 0 4px alpha(${colors.base0D}, 0.2),
                    inset 0 1px 2px alpha(${colors.base07}, 0.2);
        transform: translateY(-2px);
      }

      /* Password dots */
      #input-field text {
        color: ${colors.base05};
      }

      /* Placeholder - subtle, elegant */
      #input-field placeholder {
        color: ${colors.base03};
        font-style: italic;
      }

      /* User info container */
      #user-box {
        margin-top: 40px;
      }

      /* User label - subtle presence */
      #user-label {
        font-family: "${fonts.sansSerif.name}";
        font-size: 20px;
        font-weight: 400;
        color: white;
        background-color: rgba(0, 0, 0, 0.8);
        padding: 8px 16px;
        border-radius: 8px;
      }

      /* Message/error labels - attention grabbing */
      #message-label, #error-label {
        font-family: "${fonts.sansSerif.name}";
        font-size: 16px;
        font-weight: 500;
        color: ${colors.base08};
        background-color: alpha(${colors.base08}, 0.2);
        border-left: 4px solid ${colors.base08};
        padding: 12px 20px;
        border-radius: 8px;
        margin-top: 20px;
        box-shadow: 0 4px 16px alpha(${colors.base08}, 0.3);
      }

      /* Buttons - modern, smooth */
      button {
        background: linear-gradient(135deg, alpha(${colors.base02}, 0.9), alpha(${colors.base01}, 0.7));
        color: ${colors.base05};
        border: 1px solid alpha(${colors.base03}, 0.6);
        border-radius: 8px;
        padding: 12px 24px;
        font-family: "${fonts.sansSerif.name}";
        font-size: 16px;
        font-weight: 500;
        min-height: 44px;
        box-shadow: 0 4px 12px alpha(${colors.base00}, 0.4);
        transition: all 200ms ease;
      }

      button:hover {
        background: linear-gradient(135deg, alpha(${colors.base03}, 0.95), alpha(${colors.base02}, 0.8));
        border-color: ${colors.base0D};
        box-shadow: 0 6px 20px alpha(${colors.base0D}, 0.3);
        transform: translateY(-1px);
      }

      button:active {
        transform: translateY(0);
        box-shadow: 0 2px 8px alpha(${colors.base00}, 0.4);
      }

      /* Spinner/loading indicator */
      spinner {
        color: ${colors.base0D};
      }

      /* Smooth animations */
      * {
        transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
      }
    '';

    # Override DMS lock and suspend commands
    programs.dank-material-shell.settings = {
      customPowerActionLock = cfg.lockCommand;
      customPowerActionSuspend = cfg.suspendCommand;
    };
  };
}
