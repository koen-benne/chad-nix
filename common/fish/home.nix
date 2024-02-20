{ config, lib, pkgs, ... }:

let
  inherit (lib) mdDoc mkEnableOption mkIf;
  cfg = config.my.fish;
in
{
  options.my.fish = {
    enable = mkEnableOption (mdDoc "fish");
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fd
    ];

    programs.fzf.enable = true;
    # programs.zoxide.enable = true;
    programs.fish = {
      enable = true;
      shellInit = ''
        if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
          source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        end
      '';
      interactiveShellInit = ''
        set -U Z_CMD "j"
        set -gx DIRENV_LOG_FORMAT ""
        set -gx DYLD_LIBRARY_PATH ${pkgs.imagemagick}/lib
        set -g fish_greeting
        # add .local/bin to path using fish's function for adding paths
        fish_add_path $HOME/.local/bin
      '';
      shellAliases = {
        vim = "nvim";
        lg = "lazygit";
        ll = "ls -lah";
        shell = "export NIXPKGS_ALLOW_INSECURE=1 && nix shell --impure";
        to = "turbotmux open";
        tc = "turbotmux close";
        tp = "turbotmux project";
        tn = "turbotmux new";
        darwin-switch = "darwin-rebuild switch --flake ~/.config/chad-nix";
        darwin-update = "nix flake update ~/.config/chad-nix";
      };
      plugins = [
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "ddeb28a7b6a1f0ec6dae40c636e5ca4908ad160a";
            sha256 = "0c5i7sdrsp0q3vbziqzdyqn4fmp235ax4mn4zslrswvn8g3fvdyh";
          };
        }
        {
          name = "eclm";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "theme-eclm";
            rev = "185c84a41947142d75c68da9bc6c59bcd32757e7";
            sha256 = "1gx7y6b752wvrahw9krdh54g84mapb6nir053nvyni0c1kijw69q";
          };
        }
        # {
        #   name = "wakatime";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "ik11235";
        #     repo = "wakatime.fish";
        #     rev = "cb88b955546642b0d41c80d14ae740a4426c4fbb";
        #     sha256 = "03b5yrldfsz3ypjmw90qlwd8dfp721664g202yhbclqdz67gqimp";
        #   };
        # }
      ];
    };
  };
}
