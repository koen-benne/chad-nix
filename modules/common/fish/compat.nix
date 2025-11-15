{
  config,
  lib,
  pkgs,
  ...
}: {
  # Fish shell default shell setup for home-manager standalone mode
  # This handles setting fish as the default shell, which requires system-level changes
  # that home-manager can't do automatically in standalone mode
  
  config = lib.mkIf config.my.fish.enable {
    # Test to verify this compat module is loaded
    home.activation.fishCompatTest = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "🐟 Fish compat.nix is loaded!"
    '';
    
    home.activation.setDefaultShell = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "🐟 Setting up fish as default shell..."
      
      # Try to find fish in various locations
      fishPath=""
      nixFishPath="${config.programs.fish.package}/bin/fish"
      userLocalFish="$HOME/.local/bin/fish"
      
      # Check potential locations in order of preference
      for path in \
        "$userLocalFish" \
        "$HOME/.nix-profile/bin/fish" \
        /usr/local/bin/fish \
        /usr/bin/fish \
        /bin/fish; do
        if [[ -x "$path" ]]; then
          fishPath="$path"
          echo "📍 Found fish at $fishPath"
          break
        fi
      done
      
      # If no stable fish found, create a symlink in ~/.local/bin
      if [[ -z "$fishPath" ]]; then
        echo "⚠️  No fish found in standard locations."
        echo "   Setting up user-local symlink to nix-managed fish..."
        
        # Create ~/.local/bin if it doesn't exist
        mkdir -p "$HOME/.local/bin"
        
        # Create symlink to nix fish
        if ln -sf "$nixFishPath" "$userLocalFish" 2>/dev/null; then
          fishPath="$userLocalFish"
          echo "✅ Created symlink: $fishPath -> $nixFishPath"
          
          # Add ~/.local/bin to PATH if not already there
          if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            echo "⚠️  Note: $HOME/.local/bin is not in your PATH"
            echo "   Add this to your shell rc file: export PATH=\"\$HOME/.local/bin:\$PATH\""
          fi
        else
          echo "❌ Failed to create symlink"
          echo "   Alternative options:"
          echo "   1. Install system fish: sudo apt install fish (or your distro equivalent)"
          echo "   2. Use nix profile: nix profile install nixpkgs#fish"
          echo "   3. Create symlink manually: ln -sf '$nixFishPath' ~/.local/bin/fish"
          exit 0
        fi
      fi
      
      # Check if fish is already in /etc/shells
      if ! grep -Fxq "$fishPath" /etc/shells 2>/dev/null; then
        echo "📝 Adding fish to /etc/shells (requires sudo)..."
        if command -v sudo >/dev/null 2>&1; then
          if echo "$fishPath" | sudo tee -a /etc/shells >/dev/null 2>&1; then
            echo "✅ Successfully added fish to /etc/shells"
          else
            echo "❌ Failed to add fish to /etc/shells"
            echo "   Please run manually: echo '$fishPath' | sudo tee -a /etc/shells"
            exit 0
          fi
        else
          echo "❌ sudo not available. Please add fish to /etc/shells manually:"
          echo "   echo '$fishPath' | sudo tee -a /etc/shells"
          exit 0
        fi
      else
        echo "✅ Fish is already in /etc/shells"
      fi
      
      # Change default shell
      # Try multiple ways to get current shell (getent not always available)
      currentShell=""
      if command -v getent >/dev/null 2>&1; then
        currentShell="$(getent passwd "$USER" 2>/dev/null | cut -d: -f7)"
      elif [[ -r /etc/passwd ]]; then
        currentShell="$(grep "^$USER:" /etc/passwd 2>/dev/null | cut -d: -f7)"
      else
        currentShell="$SHELL"
      fi
      
      # Fallback if we couldn't determine current shell
      if [[ -z "$currentShell" ]]; then
        currentShell="$SHELL"
      fi
      if [[ "$currentShell" != "$fishPath" ]]; then
        echo "🔄 Changing default shell from $currentShell to fish..."
        if command -v chsh >/dev/null 2>&1; then
          if chsh -s "$fishPath" 2>/dev/null; then
            echo "✅ Successfully changed default shell to fish"
            echo "   Please log out and back in, or restart your terminal"
          else
            echo "❌ Failed to change default shell automatically"
            echo "   Please run manually: chsh -s '$fishPath'"
          fi
        else
          echo "❌ chsh command not available"
          echo "   Please change your shell manually or configure your terminal to use fish"
        fi
      else
        echo "✅ Fish is already your default shell"
      fi
      
      echo "🐟 Fish shell setup complete!"
    '';
  };
}