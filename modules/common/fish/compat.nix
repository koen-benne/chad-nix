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
      fishPath="${config.programs.fish.package}/bin/fish"
      
      echo "🐟 Setting up fish as default shell..."
      
      # Check if fish path exists
      if [[ ! -x "$fishPath" ]]; then
        echo "❌ Fish binary not found at $fishPath"
        exit 1
      fi
      
      # Add fish to /etc/shells if not already present
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
      currentShell="$(getent passwd "$USER" | cut -d: -f7)"
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