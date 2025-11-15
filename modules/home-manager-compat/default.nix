# Home-Manager Compatibility Layer
# 
# Auto-discovers compat.nix files from common and nixos modules to provide 
# the sys.* options that home.nix files expect when running home-manager 
# standalone on Linux systems that can't use NixOS system management.
# 
# This ensures existing home.nix files work unchanged without needing
# to maintain separate home-manager-only versions.
#
# Features:
# - Sets config.my.isStandalone = true for detection in home.nix modules
# - Provides sys.* options via compat.nix files
# - Makes sys available as alias to config for backward compatibility
#
# Usage in home.nix modules:
#   footCommand = if config.my.isStandalone 
#     then "${nixgl}/bin/nixGL foot" 
#     else "foot";
{ config, lib, ... }: {
  imports = 
    # Auto-discovery of compat.nix files
    lib.my.getCompatModules [../common ../nixos]
    ++ [
    # Home-manager standalone specific modules
    ./system-setup
    ./nixgl-desktop
    ./tuigreet
    
    # Special cases that stay manual
    ./kitty.nix      # Darwin-specific, no nixos equivalent
  ];

  config = {
    # Detection flag for home-manager standalone mode
    my.isStandalone = true;
    
    # Make sys available as an alias to config for home.nix files
    # This mimics the behavior of extraSpecialArgs = { sys = config; }
    _module.args.sys = config;
  };
}

