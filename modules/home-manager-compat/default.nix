# Home-Manager Compatibility Layer
# 
# These modules provide the sys.* options that home.nix files expect
# when running home-manager standalone on systems that can't use 
# NixOS/nix-darwin system management (like Debian, Ubuntu, etc.).
# 
# This ensures existing home.nix files work unchanged without needing
# to maintain separate home-manager-only versions.
{
  imports = [
    ./desktop.nix
    ./gaming.nix
    ./hyprland.nix
    ./kitty.nix
    ./lockscreen.nix
    ./networking.nix
    ./opencode.nix
    ./openssl.nix
    ./theme.nix
    ./uxplay.nix
    ./virtualisation.nix
  ];
}