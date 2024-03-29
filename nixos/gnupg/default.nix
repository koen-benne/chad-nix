{ config, lib, pkgs, ... }:

{
  services.dbus.packages = [ pkgs.gcr ];
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };
}
