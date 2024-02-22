{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    (pass.withExtensions (ext: [ ext.pass-otp ]))
    age
    gcc
    curl
    diffutils
    stow
    file
    findutils
    gawk
    gnupg
    gzip
    btop
    imagemagick
    ipcalc
    jq
    man
    openssh
    python3
    ripgrep
    scripts
    jetbrains-mono-nerdfont
  ];
}
