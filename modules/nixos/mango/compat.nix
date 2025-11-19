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

  config = mkIf cfg.enable {
    wayland.windowManager.mango.enable = true;

    # Portal configuration - GNOME portal first, wlr as fallback
    xdg.configFile."xdg-desktop-portal/mango-portals.conf".text = ''
      [preferred]
      default=gnome
      org.freedesktop.impl.portal.Screencast=gnome
      org.freedesktop.impl.portal.Screenshot=gnome
      org.freedesktop.impl.portal.FileChooser=gnome
      org.freedesktop.impl.portal.Settings=gnome
    '';

    # Mango-specific packages for standalone mode
    home.packages = [
      pkgs.polkit_gnome
    ];

    # Session environment variables (mango's home manager module handles most of these)
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
      echo "Optional for fallback:"
      echo "  sudo apt install xdg-desktop-portal-wlr    # fallback for screen capture"
      echo ""
      echo "Portal setup:"
      echo "  GNOME portal is preferred for better app integration and file dialogs"
      echo "  wlr portal serves as fallback if gnome portal has issues"
      echo ""
      echo "Optional but recommended:"
      echo "  sudo apt install pipewire pipewire-pulse wireplumber"
      echo "  sudo apt install polkit-1 policykit-1-gnome"
      echo ""
      echo "To start mango session:"
      echo "  Run 'mango' directly (no special session command needed)"
      echo ""
      echo "After installing, restart your session or reboot."
      echo ""
      echo "═══════════════════════════════════════════════════════════════"
      echo ""
    '';
  };
}
