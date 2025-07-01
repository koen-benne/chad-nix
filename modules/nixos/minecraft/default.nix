# TODO; work with the variables available so that this doesn't just work for tnauwiecraft
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
      # managementSystem.tmux.enable = false;
      # managementSystem.systemd-socket.enable = true;

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
            max-tick-time = 60000;
            online-mode = true;
            reduced-debug-info = false;
          };

          whitelist = {
            YerBoyCone = "ef4f6857-d513-4dd5-8595-cd9711743a55";
            RWDLegend = "df9e46f9-d8a3-4092-a970-ff0bce9e6aef";
            MR_REY = "815687a1-0a07-447b-bc3e-4ea3f423e7d0";
          };

          jvmOpts = "-Xmx8G -Xms6G";
          symlinks = {
            "mods" = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
              TreeHarvester = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/abooMhox/versions/aROMAonE/treeharvester-1.21.3-9.0.jar";
                sha512 = "b8d5c699d6bf4b26225454302f25a874c2dae078016db33398afb753e32ae23337c3c527467389c795408d894f34159a3f18c4f34ac20aaad299ff97f5685055";
              };
              Collective = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/UqTBXnWC/collective-1.21.3-7.89.jar";
                sha512 = "f8eace73d57e858330e2e15e76767512964c7b4b6aa592a61c29e641d2fda46d548dfc18c67a824c0a16a3da8ae9e1b585de3846e39306789eda98c02bcf7aad";
              };
              FabricAPI = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/FjU3tsgY/fabric-api-0.107.0%2B1.21.3.jar";
                sha512 = "f02d4a11e39075333141936816310dbc6131a5c335ea34760bcd69937c3effc20401da5a61c49beaf5ee522330db9fd87beb3d952cea84124eb1691f909fca00";
              };
              Noisium = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/KuNKN7d2/versions/M4c8aGZ4/noisium-fabric-2.4.0%2Bmc1.21.2-1.21.3.jar";
                sha512 = "cc049b37fce73ea4d12b42753a0abecc8f29104bb0b397e3b79fab2f6c957794a8e704c339d87789e3217d0371e31c49d71eff5ca31d1a042e5b5ab869aca844";
              };
              # TODO: One of these two is causing issues
              # FerriteCore = pkgs.fetchurl {
              #   url = "https://cdn.modrinth.com/data/uXXizFIs/versions/a3QXXGz2/ferritecore-7.1.0-hotfix-fabric.jar";
              #   sha512 = "ae1ab30beb5938643cf2ae7b8220769f2c917e3f5441e46e9bc900295348c0a541a325c30b8dfc38039205620d872c27809acdc6741351f08e4c8edc36ae2bcc";
              # };
              # Lithium = pkgs.fetchurl {
              #   url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/9x0igjLz/lithium-fabric-mc1.21.1-0.13.1.jar";
              #   sha512 = "4250a630d43492da35c4c197ae43082186938fdcb42bafcb6ccad925b79f583abdfdc17ce792c6c6686883f7f109219baecb4906a65d524026d4e288bfbaf146";
              # };
              # Krypton = pkgs.fetchurl {
              #   url = "https://cdn.modrinth.com/data/fQEb0iXm/versions/Acz3ttTp/krypton-0.2.8.jar";
              #   sha512 = "5f8cf96c79bfd4d893f1d70da582e62026bed36af49a7fa7b1e00fb6efb28d9ad6a1eec147020496b4fe38693d33fe6bfcd1eebbd93475612ee44290c2483784";
              # };
              Spark = pkgs.fetchurl {
                url = "https://cdn.modrinth.com/data/l6YH9Als/versions/D4nCQOay/spark-1.10.115-fabric.jar";
                sha512 = "07c760c460f50e31758171151d57f459a020c8b480d326f45a019242956f36572d05cebd36daa03f7c104239d805c5716082aef0a51465cc593dd39a9bd8712f";
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
