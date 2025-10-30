{
  lib,
  pkgs,
  ...
}: {
  config = {
    # Set the host platform
    nixpkgs.hostPlatform = "x86_64-linux";
    
    # System packages
    environment.systemPackages = with pkgs; [
      htop
      git
      vim
      curl
      wget
    ];
    
    # Example configuration files
    environment.etc = {
      "system-manager-example.conf".text = ''
        # Example configuration managed by system-manager
        managed_by = "system-manager"
        host = "system-manager-example"
      '';
    };
    
    # Example systemd services
    systemd.services.example-service = {
      enable = true;
      description = "Example service managed by system-manager";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${lib.getBin pkgs.coreutils}/bin/echo 'Hello from system-manager!'";
      };
      wantedBy = ["system-manager.target"];
    };
    
    # Example tmpfiles rules
    systemd.tmpfiles.rules = [
      "D /var/tmp/system-manager-example 0755 root root -"
    ];
  };
}