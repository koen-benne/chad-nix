{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.mango;
in {
  options.my.mango = {
    enable = mkEnableOption (mdDoc "mango scrollable-tiling wayland compositor");
  };

  imports = [
    inputs.mango.hmModules.mango
  ];

  config = mkIf cfg.enable {
    wayland.windowManager.mango.enable = true;

    # Systemd user service integration for non-NixOS systems
    systemd.user.services = {
      # Ensure graphical-session.target is started for portal dependencies
      mango-session-setup = {
        Unit = {
          Description = "Setup mango session environment";
          Before = [ "xdg-desktop-portal.service" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "mango-session-setup" ''
            # Reset any failed graphical session units
            for unit in $(systemctl --user --no-legend --state=failed --plain list-units | cut -f1 -d' '); do
              partof="$(systemctl --user show -p PartOf --value "$unit")"
              if [ "$partof" = "graphical-session.target" ]; then
                systemctl --user reset-failed "$unit"
              fi
            done

            # Import environment variables into systemd user session
            systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP

            # Start graphical session target
            systemctl --user start graphical-session.target
          '';
          RemainAfterExit = true;
        };
        Install.WantedBy = [ "mango.service" ];
      };

      # PolicyKit authentication agent
      polkit-gnome-authentication-agent = {
        Unit = {
          Description = "PolicyKit Authentication Agent";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };

    # Session environment variables
    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "mango";
      XDG_SESSION_TYPE = "wayland";
    };

    # Instructions for non-NixOS system setup
    home.activation.mangoSystemRequirements = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo ""
      echo "═══════════════════════════════════════════════════════════════"
      echo "  Mango setup requires these system packages (install via apt):"
      echo "═══════════════════════════════════════════════════════════════"
      echo ""
      echo "Required packages:"
      echo "  sudo apt install xdg-desktop-portal xdg-desktop-portal-gnome"
      echo ""
      echo "Optional but recommended:"
      echo "  sudo apt install pipewire pipewire-pulse wireplumber"
      echo "  sudo apt install polkit-1 policykit-1-gnome"
      echo ""
      echo "After installing, restart your session or reboot."
      echo ""
      echo "To verify portal functionality:"
      echo "  systemctl --user status xdg-desktop-portal"
      echo "  busctl --user tree org.freedesktop.portal.Desktop"
      echo ""
      echo "═══════════════════════════════════════════════════════════════"
      echo ""
    '';
  };
}