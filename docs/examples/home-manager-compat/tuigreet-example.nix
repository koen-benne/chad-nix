# Example tuigreet configuration for home-manager standalone mode
# This provides tuigreet installation, theming, and setup helpers

{
  # Enable tuigreet module
  my.tuigreet.enable = true;
  
  # Configure default session (what tuigreet launches)
  my.tuigreet.defaultSession = "Hyprland"; # or "sway", "gnome-session", etc.
  
  # Install tuigreet via home-manager (default: true)
  my.tuigreet.installPackage = true;
  
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
# 1. **tuigreet package** - Installed via home-manager
# 2. **Example greetd config** - ~/.config/tuigreet/example-greetd-config.toml
# 3. **Theme configuration** - ~/.config/tuigreet/theme.toml  
# 4. **Setup helper script** - ~/.local/bin/setup-tuigreet
# 
# The setup helper will:
# - Check if greetd is installed system-wide
# - Verify tuigreet is in PATH
# - Check greetd service status
# - Provide copy-paste commands for system setup
# - Help disable other display managers
# 
# Manual steps still required:
# 1. Install greetd system package
# 2. Copy config: sudo cp ~/.config/tuigreet/example-greetd-config.toml /etc/greetd/config.toml
# 3. Enable service: sudo systemctl enable greetd
# 4. Disable other DMs: sudo systemctl disable gdm sddm lightdm