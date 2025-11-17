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
    programs.niri.package = inputs.niri.packages.${pkgs.system}.niri-stable;

    # XDG Desktop Portal configuration
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
      ];
      config = {
        common = {
          default = "gnome";  # This tells portals to use GNOME backends
          "org.freedesktop.impl.portal.Screencast" = "gnome";
          "org.freedesktop.impl.portal.Screenshot" = "gnome";
        };
      };
    };

    # Manually install the systemd services for Home Manager
    xdg.configFile = {
      "systemd/user/niri.service".source = "${config.programs.niri.package}/lib/systemd/user/niri.service";
      "systemd/user/niri-shutdown.target".source = "${config.programs.niri.package}/lib/systemd/user/niri-shutdown.target";
    };

    # Reload systemd after installing the services
    home.activation.reloadSystemd = lib.hm.dag.entryAfter ["linkGeneration"] ''
      $DRY_RUN_CMD ${pkgs.systemd}/bin/systemctl --user daemon-reload
    '';

    home.packages = [
      pkgs.polkit_gnome
    ];

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
          Before = [ "xdg-desktop-portal.service" ];
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

            # Start graphical session target
            systemctl --user start graphical-session.target
          '';
          RemainAfterExit = true;
        };
        Install.WantedBy = [ "niri.service" ];  # Now this will work!
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
  };
}
