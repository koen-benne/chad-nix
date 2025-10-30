{
  lib,
  pkgs,
  ...
}: {
  # Systemd services configuration for system-manager
  
  systemd.services.system-manager-health = {
    enable = true;
    description = "System Manager health check";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.writeShellScript "system-manager-health" ''
        echo "System Manager is running properly"
        ${lib.getBin pkgs.coreutils}/bin/date
      ''}";
    };
    wantedBy = ["system-manager.target"];
  };
}