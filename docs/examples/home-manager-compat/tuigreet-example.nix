# Example tuigreet configuration for home-manager standalone mode
# This provides tuigreet theming, configuration helpers, and setup guidance
# IMPORTANT: Install greetd and tuigreet via your native package manager for best compatibility

{
  # Enable tuigreet module
  my.tuigreet.enable = true;
  
  # Configure default session (what tuigreet launches)
  my.tuigreet.defaultSession = "Hyprland"; # or "sway", "gnome-session", etc.
  
  # Install tuigreet via home-manager (NOT recommended - use native packages instead)
  my.tuigreet.installPackage = false; # Keep false - install via system package manager
  
  # Generate helper configs and scripts (default: true)
  my.tuigreet.generateConfigs = true;
  
  # Customize tuigreet theme (gruvbox-inspired by default)
  my.tuigreet.theme = {
    background = "282828";  # Dark background
    border = "458588";      # Blue-green borders
    text = "ebdbb2";        # Light text
    prompt = "b8bb26";      # Green prompts
    time = "83a598";        # Blue time display
    action = "d3869b";      # Purple action buttons
    button = "fabd2f";      # Yellow buttons
    container = "3c3836";   # Dark containers
    input = "504945";       # Input field background
  };
}

# What this provides:
# 
# 1. **Theme configuration** - ~/.config/tuigreet/theme.toml  
# 2. **Example greetd config** - ~/.config/tuigreet/example-greetd-config.toml
# 3. **Setup helper script** - ~/.local/bin/setup-tuigreet
# 4. **Installation guidance** - Strongly recommends native package manager
# 
# The setup helper will:
# - Guide native package installation (greetd + tuigreet)
# - Detect mixed Nix/system installations and warn about compatibility
# - Check greetd service status and configuration
# - Verify PAM configuration and user permissions
# - Provide copy-paste commands for system setup
# - Help disable conflicting display managers
# 
# RECOMMENDED installation steps:
# 1. Install native packages:
#    - Ubuntu: sudo apt install greetd greetd-tuigreet
#    - Fedora: sudo dnf copr enable peterwu/greetd && sudo dnf install greetd greetd-tuigreet  
#    - Arch: sudo pacman -S greetd greetd-tuigreet
# 2. Run setup helper: ~/.local/bin/setup-tuigreet
# 3. The helper will guide the remaining configuration steps