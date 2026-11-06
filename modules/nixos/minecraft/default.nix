# TODO; work with the variables available so that this doesn't just work for tnauwiecraft
{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.mc-servers;
in {
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  options.my.mc-servers = {
    enable = mkEnableOption "minecraft servers";
  };

  config = mkIf cfg.enable {

    # Required for simple voice chat mod
    networking.firewall.allowedUDPPorts = [24454];

    users.users.${config.my.user}.extraGroups = ["minecraft"];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;
      # managementSystem.tmux.enable = false;
      # managementSystem.systemd-socket.enable = true;

      servers = {
        tnauwiecraft = {
          enable = true;
          package = pkgs.fabricServers.fabric-26_3.override {
            jre_headless = pkgs.openjdk25_headless;
          };

          serverProperties = {
            motd = "Tnauwiecraft";
            white-list = true;
            server-port = 25565;
            difficulty = "normal";
            gamemode = "survival";
            max-players = 3;
            max-tick-time = 60000;
            online-mode = true;
            reduced-debug-info = false;
          };

          whitelist = {
            YerBoyCone = "ef4f6857-d513-4dd5-8595-cd9711743a55";
            RWDLegend = "df9e46f9-d8a3-4092-a970-ff0bce9e6aef";
            DoreeAgrien = "1ee9f756-8ff7-4d82-8255-61989653f753";
            CertifiedAsian = "acdc9485-f538-4dd6-b0ab-0aa80e8155ab";
            Lil_Noodle74 = "8ea88e86-89f1-4399-b236-0a81c783bf7b";
            pappiecx = "2818d794-a46b-4809-a8f5-fb6011255a2a";
          };

          jvmOpts = "-Xmx8G -Xms6G";
          symlinks = {
            "mods" = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {

              # Shift break trees with axe
              TreeHarvester = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/abooMhox/versions/Aem5iZWT/treeharvester-26.3.0-10.3.jar";
                hash = "sha512-xL+0Nl6MraKCazJOdhXrk0lRqYu3sfAVE8BuczlBY+wy5fYe7usYZHVALVTGyBft0GKmm29eZVCSeKq+8vLiIA==";
              };

              # Libraries
              Collective = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/94WEkZry/collective-26.3.0-8.60.jar";
                hash = "sha512-Mwm1zDlIanfTEVUjGuVMkQDNkXBUFmI/zz/sn2mIeMIuigOOuPg4eHjHMYSWgmaTldx3mnUW7Maf9fIl+JX0Zg==";
              };
              FabricAPI = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/LEklt8GT/fabric-api-0.164.0%2B26.3.jar";
                hash = "sha512-LOewgm91gBpW6BUOtc7KRnzfi0tE4WC1pTgeVBJWfQJPRqFsZ58pxKk0ayaH+hdA+R7WAmoxsu0fPUtQNZaNaQ==";
              };
              zconfig = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/4qmvXRB9/versions/tsgt79sG/zconfig-1.0.0%2B26.x.jar";
                hash = "sha512-uvh6wCP9Apf1MYl/Dc3Kw7CzWWBoMJCtszUKIoGiEcUTSlNzcwoQYoMAyvVxG5EnBfFrM6HRpzo6hvNGvNfG9Q==";
              };

              # Performance mods
              FastNoise = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/OnlVIpq5/versions/cCGI5KLE/zfastnoise-1.1.1%2B26.3.jar";
                hash = "sha512-geniBj+sMyk7FHAbfHK5Iv69per1x8Yxq59YjJa6g13339FNysZ2P0FOgzZsckRf365NdLp/eptzcHRGomTIfw==";
              };
              FerriteCore = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/uXXizFIs/versions/d5ddUdiB/ferritecore-9.0.0-fabric.jar";
                hash = "sha512-2B+pfhF4TBnUL4nC9DODHQB2A91xk87kX6F35KapxSs4SxmFhuBKD39jzZlv7XEzIleL3pqNtX4RiIVK5cvlhA==";
              };
              Lithium = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/xS0Q8LSi/lithium-fabric-0.26.2%2Bmc26.3.jar";
                hash = "sha512-TX/uZhMu7ccf6rk5C5LJXXBY7b2tD+z6wdg2opULl6fKRjr77eYcfvNhzmXh+Sernond5b8uDgzkhq+1xdvuQA==";
              };
              Krypton = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/UugdIYJw/krypton-0.3.2.jar";
                hash = "sha512-0dV+vUE5W3WwHxMM2VA+uNIIISQko5n/nzZ/UL6PvBxkckQrM8aG53fDFI9qYJUg6PtzLHVRV8NYyyB/1NESOg==";
              };

              # For Voxy
              Chunksmith = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/4BeAEBIb/versions/Sun3j32A/chunksmith-4.6.0%2B26.3.jar";
                hash = "sha512-ah2STbmi8JyYOwRj/C58c3TiUYWmMmBdrvn3H0GnGCpoBPuLdE+xf3UTsQQSaDbee3eaUmxlYN5bUGMJ+kBVwg==";
              };

              # Map stuff
              XaerosMinimap = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/1bokaNcj/versions/eUEhnw8G/xaerominimap-fabric-26.3-26.6.1.jar";
                hash = "sha512-qSR/bh28OUacaP56F9Siq1fBgS9KWGshzaPX0hspN3Elhkz8mFY2AGpvz1Pxsx8fq7dbpISDasBpOcRbAF8NgQ==";
              };
              XaerosWorldMap = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/NcUtCpym/versions/IEtfiHVq/xaeroworldmap-fabric-26.3-1.47.1.jar";
                hash = "sha512-o+EDnKRoBPXzK4tlq0V1C0OEGRmwRzvJTxLyvjaI86GzUe4LJeRVlt7crr0oEap2D4SFqYWhkrCiVb5hfy2KbA==";
              };

              # Proximity chat
              SimpleVoiceChat = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/cZm965sW/voicechat-fabric-2.6.26%2B26.3.jar";
                hash = "sha512-c4q1fwStFBr5QHSEJWdytPf16V/fjt9vE09qBXCF6y3fS1x9qIcU4+lKbkroaouYUHGkwzNIUEfuUqlwaEWhAA==";
              };
              SVCEnhancedGroups = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/1LE7mid6/versions/bxfWYs0a/enhancedgroups-fabric-1.8.0%2B26.3.jar";
                hash = "sha512-YIACbv+X/2wPSfCle2mBfTEA5+qbHvZ/QdWIHqoGrKQu8GpOdTGlZvXFeeB8OC/UJkK+sz/gQnDpMD2LM3IOpQ==";
              };
            });
          };
        };
        # tnauwiecreative = {
        #   enable = true;
        #   package = pkgs.fabric-server;
        #
        #   serverProperties = {
        #     motd = "Tnauwiecreative";
        #     white-list = true;
        #     server-port = 25566;
        #     difficulty = "normal";
        #     gamemode = "creative";
        #     max-players = 3;
        #     online-mode = true;
        #     reduced-debug-info = false;
        #   };
        #
        #   whitelist = {
        #     YerBoyCone = "ef4f6857-d513-4dd5-8595-cd9711743a55";
        #     RWDLegend = "df9e46f9-d8a3-4092-a970-ff0bce9e6aef";
        #     MR_REY = "815687a1-0a07-447b-bc3e-4ea3f423e7d0";
        #   };
        #
        #   jvmOpts = "-Xmx4G -Xms4G";
        #   symlinks = {
        #   };
        # };
      };
    };
  };
}
