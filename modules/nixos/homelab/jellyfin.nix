# File: modules/homelab/jellyfin.nix
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf mkOption types;
  cfg = config.my.homelab.jellyfin;
  homelabCfg = config.my.homelab;
in {
  options.my.homelab.jellyfin = {
    enable = mkEnableOption (mdDoc "Jellyfin media server");

    subdomain = mkOption {
      type = types.str;
      default = "jellyfin";
      description = mdDoc "Subdomain for Jellyfin";
    };

    port = mkOption {
      type = types.port;
      default = 8096;
      description = mdDoc "Port for Jellyfin web interface";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/jellyfin";
      description = mdDoc "Data directory for Jellyfin";
    };

    mediaLibraries = mkOption {
      type = types.attrsOf types.path;
      default = {
        movies = "/export/1tb/Media/Movies";
        tv = "/export/1tb/Media/TV";
        music = "/export/1tb/Media/Music";
      };
      description = mdDoc "Media library paths to mount in Jellyfin";
      example = {
        movies = "/mnt/storage/movies";
        tv = "/mnt/storage/tv";
        music = "/mnt/storage/music";
        books = "/mnt/storage/books";
      };
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc "Open firewall for direct access to Jellyfin port (not needed if using nginx proxy)";
    };

    enableHardwareAcceleration = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc "Enable hardware acceleration (requires appropriate hardware)";
    };
  };

  config = mkIf (homelabCfg.enable && cfg.enable) {
    # Enable Jellyfin service
    services.jellyfin = {
      enable = true;
      dataDir = cfg.dataDir;
      openFirewall = cfg.openFirewall;
    };

    # Create media directories and set permissions
    system.activationScripts.jellyfin-setup = ''
      # Create media library directories if they don't exist
      ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: path: ''
        mkdir -p ${path}
        chown -R jellyfin:jellyfin ${path}
        chmod -R 755 ${path}
      '') cfg.mediaLibraries)}

      # Ensure Jellyfin data directory has correct permissions
      mkdir -p ${cfg.dataDir}
      chown -R jellyfin:jellyfin ${cfg.dataDir}
    '';

    # Bind mount media libraries to Jellyfin-accessible locations
    fileSystems = lib.mapAttrs' (name: sourcePath: 
      lib.nameValuePair "/var/lib/jellyfin/media/${name}" {
        device = sourcePath;
        options = [ "bind" "ro" ]; # Read-only for safety
      }
    ) cfg.mediaLibraries;

    # Add Jellyfin virtual host to nginx if nginx is enabled
    services.nginx.virtualHosts = mkIf config.my.homelab.nginx.enable {
      "${cfg.subdomain}.${homelabCfg.domain}" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.port}";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Protocol $scheme;
            proxy_set_header X-Forwarded-Host $http_host;

            # Disable buffering when the nginx proxy gets very resource heavy upon streaming
            proxy_buffering off;
          '';
        };
      };
    };

    # Hardware acceleration setup (optional)
    hardware.graphics = mkIf cfg.enableHardwareAcceleration {
      enable = true;
    };

    # Add jellyfin user to video group for hardware acceleration
    users.users.jellyfin = mkIf cfg.enableHardwareAcceleration {
      extraGroups = [ "video" "render" ];
    };

    # System packages that might be useful for media handling
    environment.systemPackages = with pkgs; [
      ffmpeg-full
    ];
  };
}

