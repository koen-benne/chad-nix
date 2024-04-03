{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-nixos.nix
  ];
  networking = {
    hostName = "nixos";
   # usePredictableInterfaceNames = true;
   # defaultGateway = "192.168.0.1";
   # nameservers = ["8.8.8.8" "8.8.4.4"];
   firewall = {
     enable = true;
     allowedTCPPorts = [ 80 443 53317 22067 22070 ]; # 53317 is for LocalSend and 22067, 22070 are for Syncthing
     allowedUDPPortRanges = [
       { from = 4000; to = 4007; }
       { from = 53315; to = 53318; }
       { from = 8000; to = 8010; }
     ];
   };
  };

  my.desktop.enable = true;
  my.steam.enable = true;
  hm.my.zsh.enable = true;
  hm.my.foot.enable = true;
  hm.my.librewolf.enable = true;
  hm.my.spicetify.enable = true;
}
