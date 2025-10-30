{
  pkgs,
  ...
}: {
  # Basic packages available to system-manager
  environment.systemPackages = with pkgs; [
    # Core utilities
    coreutils
    findutils
    gnugrep
    gnused
    gawk
    
    # Development tools
    git
    curl
    wget
    
    # System monitoring
    htop
    btop
    
    # Text editors
    vim
    nano
  ];
}