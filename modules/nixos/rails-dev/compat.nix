# Shared local database services for Ruby/Rails development.
#
# Standalone home-manager only (no NixOS system integration): a single
# postgresql, redis and mariadb instance run as systemd user services on
# the standard ports, so every project connects straight to localhost
# instead of spinning up its own docker container per project.
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.rails-dev;

  postgresDataDir = "${config.home.homeDirectory}/.local/share/postgresql/${lib.versions.major pkgs.postgresql.version}";
  redisDataDir = "${config.home.homeDirectory}/.local/share/redis";
  mariadbDataDir = "${config.home.homeDirectory}/.local/share/mariadb/${lib.versions.majorMinor pkgs.mariadb.version}";
in {
  options.my.rails-dev = {
    enable = mkEnableOption "shared local postgresql, redis and mariadb services for rails dev";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.postgresql
      pkgs.redis
      pkgs.mariadb
    ];

    # One-time data directory initialisation. These are no-ops once the
    # data directory already exists, so they're safe to run on every switch.
    home.activation.initPostgresqlDev = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -d "${postgresDataDir}" ]; then
        $DRY_RUN_CMD mkdir -p "${postgresDataDir}"
        $DRY_RUN_CMD ${pkgs.postgresql}/bin/initdb -D "${postgresDataDir}" --auth=trust --username="$USER"
      fi
    '';

    home.activation.initMariadbDev = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [ ! -d "${mariadbDataDir}" ]; then
        $DRY_RUN_CMD mkdir -p "${mariadbDataDir}"
        $DRY_RUN_CMD ${pkgs.mariadb}/bin/mariadb-install-db --datadir="${mariadbDataDir}" --auth-root-authentication-method=normal --skip-test-db
      fi
    '';

    home.activation.initRedisDev = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p "${redisDataDir}"
    '';

    # Plain user services: no docker, no per-project containers. One shared
    # instance of each, reachable on the standard ports from any project.
    systemd.user.services = {
      postgresql = {
        Unit.Description = "PostgreSQL database server (dev)";
        Service = {
          Type = "notify";
          NotifyAccess = "all";
          ExecStart = "${pkgs.postgresql}/bin/postgres -D ${postgresDataDir} -k ${postgresDataDir} -c listen_addresses=localhost -p 5432";
          Restart = "on-failure";
        };
        Install.WantedBy = ["default.target"];
      };

      redis = {
        Unit.Description = "Redis (dev)";
        Service = {
          Type = "notify";
          ExecStart = "${pkgs.redis}/bin/redis-server --port 6379 --bind 127.0.0.1 -::1 --dir ${redisDataDir} --daemonize no --supervised systemd";
          Restart = "on-failure";
        };
        Install.WantedBy = ["default.target"];
      };

      mariadb = {
        Unit.Description = "MariaDB (dev)";
        Service = {
          Type = "notify";
          NotifyAccess = "all";
          ExecStart = "${pkgs.mariadb}/bin/mariadbd --datadir=${mariadbDataDir} --socket=${mariadbDataDir}/mysqld.sock --port=3306 --bind-address=127.0.0.1 --pid-file=${mariadbDataDir}/mariadb.pid";
          Restart = "on-failure";
        };
        Install.WantedBy = ["default.target"];
      };
    };
  };
}
