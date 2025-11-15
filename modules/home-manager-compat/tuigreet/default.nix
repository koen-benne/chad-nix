{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.tuigreet;
  
  # Generate a sample greetd config
  greetdConfig = ''
    [terminal]
    vt = 7
    switch = true
    
    [default_session]
    command = "tuigreet --time --remember --asterisks --cmd ${cfg.defaultSession}"
    user = "greetd"
    
    [initial_session]
    command = "${cfg.defaultSession}"
    user = "${config.home.username}"
  '';
  
  # Generate a tuigreet theme config
  tuigreetTheme = ''
    # Tuigreet theme configuration
    # Copy to ~/.config/tuigreet/theme.toml or use --theme flag
    
    [colors]
    background = "${cfg.theme.background}"
    border = "${cfg.theme.border}"
    text = "${cfg.theme.text}"
    prompt = "${cfg.theme.prompt}"
    time = "${cfg.theme.time}"
    action = "${cfg.theme.action}"
    button = "${cfg.theme.button}"
    container = "${cfg.theme.container}"
    input = "${cfg.theme.input}"
  '';
  
in {
  # tuigreet setup for home-manager standalone mode
  # Provides tuigreet installation and configuration helpers
  
  options.my.tuigreet = {
    enable = lib.mkEnableOption "tuigreet display manager setup";
    
    defaultSession = lib.mkOption {
      type = lib.types.str;
      default = "Hyprland";
      description = "Default session command for tuigreet";
    };
    
    installPackage = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install tuigreet package via home-manager";
    };
    
    generateConfigs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Generate example configuration files";
    };
    
    theme = {
      background = lib.mkOption {
        type = lib.types.str;
        default = "232323";
        description = "Background color (hex without #)";
      };
      
      border = lib.mkOption {
        type = lib.types.str;
        default = "458588";
        description = "Border color (hex without #)";
      };
      
      text = lib.mkOption {
        type = lib.types.str;
        default = "ebdbb2";
        description = "Text color (hex without #)";
      };
      
      prompt = lib.mkOption {
        type = lib.types.str;
        default = "b8bb26";
        description = "Prompt color (hex without #)";
      };
      
      time = lib.mkOption {
        type = lib.types.str;
        default = "83a598";
        description = "Time display color (hex without #)";
      };
      
      action = lib.mkOption {
        type = lib.types.str;
        default = "d3869b";
        description = "Action button color (hex without #)";
      };
      
      button = lib.mkOption {
        type = lib.types.str;
        default = "fabd2f";
        description = "Button color (hex without #)";
      };
      
      container = lib.mkOption {
        type = lib.types.str;
        default = "3c3836";
        description = "Container background color (hex without #)";
      };
      
      input = lib.mkOption {
        type = lib.types.str;
        default = "504945";
        description = "Input field color (hex without #)";
      };
    };
  };

  config = mkIf (cfg.enable && config.my.isStandalone) {
    # Install tuigreet if requested
    home.packages = lib.optionals cfg.installPackage [
      pkgs.greetd.tuigreet
    ];
    
    # Generate configuration files and helper scripts
    home.file = lib.mkMerge [
      (lib.mkIf cfg.generateConfigs {
        ".config/tuigreet/example-greetd-config.toml".text = greetdConfig;
        ".config/tuigreet/theme.toml".text = tuigreetTheme;
      })
      {
        ".local/bin/setup-tuigreet" = {
          text = ''
            #!/bin/bash
            # tuigreet setup helper script
            
            echo "[*] tuigreet Setup Helper"
            echo "========================="
            echo ""
            
            # Check if greetd is installed
            if ! command -v greetd >/dev/null 2>&1; then
              echo "[✗] greetd not found. Please install it first:"
              if command -v apt >/dev/null 2>&1; then
                echo "   # Ubuntu/Debian: May need third-party repo or build from source"
                echo "   # Alternative: sudo apt install lightdm"
              elif command -v dnf >/dev/null 2>&1; then
                echo "   sudo dnf copr enable peterwu/greetd"
                echo "   sudo dnf install greetd"
              elif command -v pacman >/dev/null 2>&1; then
                echo "   sudo pacman -S greetd"
              fi
              echo ""
            fi
            
            # Check if tuigreet is available
            if command -v tuigreet >/dev/null 2>&1; then
              echo "[✓] tuigreet is installed"
            else
              echo "[✗] tuigreet not found in PATH"
              echo "   Home-manager should have installed it to ~/.nix-profile/bin/"
              echo "   Make sure ~/.nix-profile/bin is in your PATH"
              echo ""
            fi
            
            # Check greetd service status
            if systemctl is-enabled greetd >/dev/null 2>&1; then
              echo "[✓] greetd service is enabled"
            else
              echo "[!] greetd service not enabled"
              echo "   Run: sudo systemctl enable greetd"
              echo ""
            fi
            
            # Check if greetd service is running
            if systemctl is-active greetd >/dev/null 2>&1; then
              echo "[✓] greetd service is running"
            else
              echo "[!] greetd service not running"
              echo "   Status: $(systemctl is-failed greetd 2>/dev/null || echo 'inactive')"
              echo "   Run: sudo systemctl start greetd"
              echo "   Check logs: sudo journalctl -u greetd -f"
              echo "   (or reboot after enabling)"
              echo ""
            fi
            
            # Check config file
            if [[ -f /etc/greetd/config.toml ]]; then
              echo "[✓] greetd config exists"
              # Check if config references tuigreet
              if grep -q "tuigreet" /etc/greetd/config.toml 2>/dev/null; then
                echo "[✓] greetd config uses tuigreet"
              else
                echo "[!] greetd config doesn't reference tuigreet"
                echo "   Update config to use: command = \"tuigreet --cmd Hyprland\""
              fi
            else
              echo "[!] greetd config missing"
              echo "   Example config available at: ~/.config/tuigreet/example-greetd-config.toml"
              echo "   Copy it: sudo cp ~/.config/tuigreet/example-greetd-config.toml /etc/greetd/config.toml"
              echo ""
            fi
            
            # Check PAM configuration
            if [[ -f /etc/pam.d/greetd ]]; then
              echo "[✓] greetd PAM config exists"
            else
              echo "[!] greetd PAM config missing"
              echo "   This is likely causing pam_authenticate errors"
              echo "   Create /etc/pam.d/greetd with:"
              echo "   ---"
              echo "   #%PAM-1.0"
              echo "   auth       include      login"
              echo "   account    include      login"
              echo "   password   include      login"
              echo "   session    include      login"
              echo "   ---"
              echo "   Run: sudo tee /etc/pam.d/greetd << 'EOF'"
              echo "   #%PAM-1.0"
              echo "   auth       include      login" 
              echo "   account    include      login"
              echo "   password   include      login"
              echo "   session    include      login"
              echo "   EOF"
              echo ""
            fi
            
            # Check greetd user
            if id greetd >/dev/null 2>&1; then
              echo "[✓] greetd user exists"
            else
              echo "[!] greetd user missing"
              echo "   Create greetd user: sudo useradd -r -s /bin/false greetd"
              echo ""
            fi
            
            # Check if other display managers are still active
            for dm in gdm sddm lightdm; do
              if systemctl is-active "$dm" >/dev/null 2>&1; then
                echo "[!] $dm is still running - this will conflict with greetd"
                echo "   Disable it: sudo systemctl disable --now $dm"
              fi
            done
            
            # Check VT availability
            if [[ -c /dev/tty7 ]]; then
              echo "[✓] VT7 available for display manager"
            else
              echo "[!] VT7 not available - may need to configure different VT"
            fi
            
            # Check if running in a desktop session
            if [[ -n "$DISPLAY" || -n "$WAYLAND_DISPLAY" ]]; then
            echo "[i] Currently in desktop session - greetd runs on boot/VT switch"
            echo "   To test now:"
            echo "     1. Switch to VT: Ctrl+Alt+F2"  
            echo "     2. Login as root/sudo user"
            echo "     3. Stop current DM: systemctl stop gdm (or sddm/lightdm)"
            echo "     4. Start greetd: systemctl start greetd"
            echo "     5. Switch to VT7: Ctrl+Alt+F7"
            echo "   Or reboot to see greetd login screen"
            fi
            
            # Disable other display managers
            echo "[i] Don't forget to disable other display managers:"
            echo "   sudo systemctl disable gdm sddm lightdm"
            echo ""
            
            # Theme info
            echo "[i] Theme configuration available at: ~/.config/tuigreet/theme.toml"
            echo "   Use with: tuigreet --theme ~/.config/tuigreet/theme.toml"
            echo ""
            
            echo "[✓] Setup complete! Reboot to use tuigreet."
            echo ""
            echo "=== Troubleshooting ==="
            echo "If greetd still doesn't start:"
            echo "1. Check logs: sudo journalctl -u greetd -f"
            echo "2. Test manually: sudo greetd --config /etc/greetd/config.toml"
            echo "3. Check VT permissions: ls -la /dev/tty7"
            echo "4. Verify no other DM running: ps aux | grep -E '(gdm|sddm|lightdm)'"
            echo "5. Check greetd user: id greetd"
          '';
          executable = true;
        };
      }
    ];
    
    # Activation message
    home.activation.tuigreetSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "[✓] tuigreet configuration generated!"
      echo "   • Example greetd config: ~/.config/tuigreet/example-greetd-config.toml"
      echo "   • Theme config: ~/.config/tuigreet/theme.toml"  
      echo "   • Setup helper: ~/.local/bin/setup-tuigreet"
      echo "   Run the setup helper for detailed instructions."
    '';
  };
}