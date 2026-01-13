# Stuff specific to a desktop version of darwin
# This structure is goddamn terrible lmao
# Works for now ig
{
  lib,
  sys,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf sys.my.desktop.enable {
    home.file.".hushlogin".text = "";
  };
}
