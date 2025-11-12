# Home-Manager Compatibility Layer
# 
# Auto-discovers compat.nix files from common and nixos modules to provide 
# the sys.* options that home.nix files expect when running home-manager 
# standalone on Linux systems that can't use NixOS system management.
# 
# This ensures existing home.nix files work unchanged without needing
# to maintain separate home-manager-only versions.
{ config, lib, ... }: {
  imports = [
    # Manual imports for testing - will switch to auto-discovery once working
    ../common/desktop/compat.nix
    ../common/opencode/compat.nix
    ../nixos/gaming/compat.nix
    ../nixos/lockscreen/compat.nix
    ../nixos/openssl/compat.nix
    ../nixos/theme/compat.nix
    ../nixos/uxplay/compat.nix
    ../nixos/virtualisation/compat.nix
    
    # Special cases that stay manual
    ./kitty.nix      # Darwin-specific, no nixos equivalent
    ./networking.nix # System-level option, doesn't fit module pattern
  ];

  # Make sys available as an alias to config for home.nix files
  # This mimics the behavior of extraSpecialArgs = { sys = config; }
  _module.args.sys = config;
}