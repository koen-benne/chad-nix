{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.my.zsh;
in {
  options.my.zsh = {
    enable = mkEnableOption "zsh";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fd
      zsh-completions
    ];

    programs.fzf.enable = true;
    programs.zsh = {
      enable = true;
    };
  };
}
