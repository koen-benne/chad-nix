{ config, lib, pkgs, ... }:

let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.fish;
in
{
  options.my.neovim = {
    enable = mkEnableOption (mdDoc "neovim");
  };

  config = mkIf cfg.enable {
    home.sessionVariables.EDITOR = "nvim";

    programs.neovim = {
      enable = true;
      package = pkgs.neovim-nightly;
      extraLuaPackages = ps: [ ps.magick ];
    };
  };
}
