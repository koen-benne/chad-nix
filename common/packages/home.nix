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
    ripgrep
    scripts
    jetbrains-mono-nerdfont
    discord

    nodejs
    nodePackages.pnpm
    nodePackages.yarn
  ];
}
