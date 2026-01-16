{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.niri;
in {
  options.my.niri = {
    enable = mkEnableOption (mdDoc "niri scrollable-tiling wayland compositor");
  };

  imports = [
    inputs.niri.homeModules.niri
    # inputs.niri.homeModules.config
    # inputs.niri.homeModules.stylix
  ];

  config = mkIf cfg.enable {
    programs.niri.enable = true;
    programs.niri.package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;

    # XDG Desktop Portal configuration
    xdg.configFile."xdg-desktop-portal/niri-portals.conf".text = ''
      [preferred]
      default=wlr
      org.freedesktop.impl.portal.Screencast=wlr
      org.freedesktop.impl.portal.Screenshot=wlr
    '';

    # Manually install the systemd services for Home Manager
    xdg.configFile = {
      "systemd/user/niri.service".source = "${config.programs.niri.package}/lib/systemd/user/niri.service";
      "systemd/user/niri-shutdown.target".source = "${config.programs.niri.package}/lib/systemd/user/niri-shutdown.target";
    };

    # Session environment variables
    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";
    };

    # Systemd user service integration for non-NixOS systems
    systemd.user.services = {
      # Ensure graphical-session.target is started for portal dependencies
      niri-session-setup = {
        Unit = {
          Description = "Setup niri session environment";
          Before = ["xdg-desktop-portal.service"];
        };
        Service = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "niri-session-setup" ''
            # Reset any failed graphical session units
            for unit in $(systemctl --user --no-legend --state=failed --plain list-units | cut -f1 -d' '); do
              partof="$(systemctl --user show -p PartOf --value "$unit")"
              if [ "$partof" = "graphical-session.target" ]; then
                systemctl --user reset-failed "$unit"
              fi
            done

            # Import environment variables into systemd user session
            systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP

            # Note: graphical-session.target is started automatically by dependencies
            # Don't start it manually as it's marked RefuseManualStart=yes
          '';
          RemainAfterExit = true;
        };
        Install.WantedBy = ["niri.service"];
      };

      # PolicyKit authentication agent
      polkit-gnome-authentication-agent = {
        Unit = {
          Description = "PolicyKit Authentication Agent";
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
        Install.WantedBy = ["graphical-session.target"];
      };
    };

    # Instructions for non-NixOS system setup
    home.activation.niriSystemRequirements = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo ""
      echo "═══════════════════════════════════════════════════════════════"
      echo "  Niri setup requires these system packages (install via apt):"
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
