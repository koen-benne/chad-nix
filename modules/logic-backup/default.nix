{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.my.logic-backup;
in {
  options.my.logic-backup = {
    enable = mkEnableOption "Enable Logic Backup";
  };
  config = mkIf cfg.enable {
    sops.secrets."backblaze/b2_logic_backup_key_id"= {
      mode = "0400";
      owner = "root";
    };
    sops.secrets."backblaze/b2_logic_backup_application_key"= {
      mode = "0400";
      owner = "root";
    };


    environment.systemPackages = [ pkgs.restic ];

    users.users.restic = {
      isNormalUser = true;
      description = "Restic Backup User";
      home = "/mnt/biggidrive/backups";
      shell = pkgs.coreutils + "/bin/true";
      group = "users";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIODP4iiY4OsxvvlRWt0UQi0pSslgNg/Vy5Dd6rH515o1 koenbenne@music-mac"
      ];
    };

    systemd.tmpfiles.rules = [
      "d /mnt/biggidrive/backups/logic 0700 restic users -"
    ];

    services.openssh = {
      enable = true;

      sftpFlags = [ "-1 INFO" ];

      extraConfig = ''
        Match User restic
          ForceCommand internal-sftp
          AllowTcpForwarding no
          X11Forwarding no
      '';
    };
  };
}

