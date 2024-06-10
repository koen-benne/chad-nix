{ config, lib, ... }:

let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.neovim;
in
{
  options.my.neovim = {
    enable = mkEnableOption (mdDoc "neovim");
  };

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "nvim";

    programs.neovim = {
      enable = true;
      extraLuaPackages = ps: [ ps.magick ];
    };
  };
}
