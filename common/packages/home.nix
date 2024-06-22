# All systems will have these packages
{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    (pass.withExtensions (ext: [ ext.pass-otp ]))
    age
    diffutils
    stow
    file
    findutils
    gawk
    gzip
    btop
    imagemagick
    ipcalc
    jq
    python3
    cargo
    ripgrep
    scripts
    jetbrains-mono-nerdfont
    openASAR
    nmap
    rippkgs


    nodejs
    # nodePackages.pnpm
    # nodePackages.yarn
  ];

  my = {
    direnv.enable = true;
    git.enable = true;
    lazygit.enable = true;
    gitui.enable = true;
    zsh.enable = true;
    fish.enable = true;
    tmux.enable = true;
  };
}
