{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mdDoc;
  cfg = config.my.kitty;
in {
  options.my.kitty = {
    enable = mkEnableOption (mdDoc "kitty");
  };

  config = mkIf cfg.enable {
    environment.etc."sudoers.d/kitty".text = ''
      Defaults env_keep += "TERMINFO_DIRS"
    '';

    hm.my.kitty.enable = true;
  };
}
