{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mdDoc;
  cfg = config.my.globalprotect;
in {
  options.my.globalprotect = {
    enable = mkEnableOption (mdDoc "GlobalProtect VPN client");
  };

  config = mkIf cfg.enable {
    # Install gpclient system-wide on NixOS for better polkit integration
    environment.systemPackages = [
      pkgs.gpclient
    ];

    # Add polkit rules to allow gpclient without password prompt
    # The gpclient needs root privileges for VPN operations
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "org.freedesktop.policykit.exec" &&
          action.lookup("program") == "${pkgs.gpclient}/bin/gpclient" &&
          subject.local == true &&
          subject.active == true &&
          subject.isInGroup("wheel")) {
            return polkit.Result.YES;
        }
      });
    '';
  };
}
