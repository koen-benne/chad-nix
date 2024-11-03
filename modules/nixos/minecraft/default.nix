{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.mc-servers;
in {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  options.my.mc-servers = {
    enable = mkEnableOption (mdDoc "minecraft servers");
  };

  config = mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers = {
        tnauwiecraft = {
          enable = true;
          package = pkgs.fabric-server;

          serverProperties = {
            motd = "Tnauwiecraft";
            white-list = true;
            server-port = 25565;
            difficulty = "normal";
            gamemode = "survival";
            max-players = 3;
            online-mode = true;
            reduced-debug-info = false;
          };

          whitelist = {
            YerBoyCone = "ef4f6857-d513-4dd5-8595-cd9711743a55";
            RWDLegend = "df9e46f9-d8a3-4092-a970-ff0bce9e6aef";
          };

          jvmOpts = "-Xmx4G -Xms4G";
          symlinks = {
            "mods" = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
              TreeHarvester = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/abooMhox/versions/aROMAonE/treeharvester-1.21.3-9.0.jar";
                sha512 = "b8d5c699d6bf4b26225454302f25a874c2dae078016db33398afb753e32ae23337c3c527467389c795408d894f34159a3f18c4f34ac20aaad299ff97f5685055";
              };
              Moonrise = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/KOHu7RCS/versions/S7ZBVFid/Moonrise-Fabric-0.2.0-beta.3%2Bbad5cae.jar";
                sha512 = "84831de3f402bd2f69fba1329412064f487571527fbb4182c45433eba3d716ef52c057d4f2e9f794821ac5147dbae774ef5c83776f4e376fc10ba3d80015cfde";
              };
            });
          };
        };
        tnauwiecreative = {
          enable = true;
          package = pkgs.fabric-server;

          serverProperties = {
            motd = "Tnauwiecreative";
            white-list = true;
            server-port = 25566;
            difficulty = "normal";
            gamemode = "creative";
            max-players = 3;
            online-mode = true;
            reduced-debug-info = false;
          };

          whitelist = {
            YerBoyCone = "ef4f6857-d513-4dd5-8595-cd9711743a55";
            RWDLegend = "df9e46f9-d8a3-4092-a970-ff0bce9e6aef";
          };

          jvmOpts = "-Xmx4G -Xms4G";
          symlinks = {
          };
        };
      };
    };
  };
}
