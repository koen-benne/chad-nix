{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];


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
        };

        jvmOpts = "-Xmx4G -Xms4G";
        symlinks = {
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
          gamemode = "survival";
          max-players = 3;
          online-mode = true;
          reduced-debug-info = false;
        };

        whitelist = {
          YerBoyCone = "ef4f6857-d513-4dd5-8595-cd9711743a55";
        };

        jvmOpts = "-Xmx4G -Xms4G";
        symlinks = {
        };
      };
    };
  };
}
