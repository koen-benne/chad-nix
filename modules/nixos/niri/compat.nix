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
    home.packages = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.polkit_gnome
      pkgs.niri
    ];

    home.activation.niriSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "Setting up niri for non-NixOS system..."
      echo ""
      echo "For full niri functionality, you need to configure:"
      echo ""
      echo "1. XDG Desktop Portals (for file pickers, screen sharing):"
      echo "   - Install xdg-desktop-portal via your system package manager"
      echo "   - Ensure it starts with your desktop session"
      echo "   - Or add this to your shell/WM startup:"
      echo "     systemctl --user start xdg-desktop-portal"
      echo ""
      echo "2. PolicyKit daemon (for privilege escalation):"
      echo "   - Install polkit via your system package manager"
      echo "   - Ensure polkitd service is running system-wide"
      echo ""
      echo "3. Display manager integration:"
      echo "   - Add niri session to your display manager"
      echo "   - Or start niri manually: $(which niri)"
      echo ""
      echo "4. Optional: PAM configuration for swaylock:"
      echo "   - Add 'swaylock' PAM service configuration"
      echo ""
      echo "Niri has been installed via home-manager but may need system setup."
    '';
  };
}
