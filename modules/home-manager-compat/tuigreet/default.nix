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
    command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd ${cfg.defaultSession}"
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
      default = false;
      description = "Install tuigreet package via home-manager (not recommended - use native package manager instead)";
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
    # Install tuigreet if requested (fallback only - prefer native package manager)
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
            # Run as regular user - will prompt for sudo when needed
            
            # Check if running as root (not recommended)
            if [[ $EUID -eq 0 ]]; then
              echo "[!] Warning: Running as root. Run as regular user instead."
              echo "   This script will use sudo when needed for system operations."
              echo ""
            fi
            
            # Check sudo access
            if ! sudo -n true 2>/dev/null; then
              echo "[i] This script needs sudo access for system configuration."
              echo "   You'll be prompted for your password when needed."
              echo ""
            fi            
            
            echo "[*] tuigreet Setup Helper"
            echo "========================="
            echo ""
            
            # Check if greetd is installed
            if ! command -v greetd >/dev/null 2>&1; then
              echo "[✗] greetd not found. Install via native package manager:"
              if command -v apt >/dev/null 2>&1; then
                echo "   # Ubuntu/Debian:"
                echo "   sudo apt update"
                echo "   sudo apt install greetd greetd-tuigreet  # If available"
                echo "   # If not available, try: sudo apt install lightdm lightdm-gtk-greeter" 
                echo "   # Or build from source: https://git.sr.ht/~kennylevinsen/greetd"
              elif command -v dnf >/dev/null 2>&1; then
                echo "   # Fedora:"
                echo "   sudo dnf copr enable peterwu/greetd"
                echo "   sudo dnf install greetd greetd-tuigreet"
              elif command -v pacman >/dev/null 2>&1; then
                echo "   # Arch Linux:"
                echo "   sudo pacman -S greetd greetd-tuigreet"
              elif command -v zypper >/dev/null 2>&1; then
                echo "   # openSUSE:"
                echo "   sudo zypper install greetd"  
              else
                echo "   # Install greetd and greetd-tuigreet via your package manager"
                echo "   # Check: https://repology.org/project/greetd/versions"
              fi
              echo ""
              echo "[!] IMPORTANT: Install both greetd AND tuigreet via native packages"
              echo "   This prevents GREETD_SOCK compatibility issues"
              echo ""
            fi
            
            # Check if tuigreet is available  
            if command -v tuigreet >/dev/null 2>&1; then
              tuigreet_path="$(command -v tuigreet)"
              echo "[✓] tuigreet is installed: $tuigreet_path"
              
              # Determine installation source
              if echo "$tuigreet_path" | grep -q "/nix/store"; then
                echo "[!] tuigreet installed via Nix - COMPATIBILITY WARNING"
                echo "   This can cause GREETD_SOCK issues with system greetd"
                echo ""
                echo "   RECOMMENDED: Install tuigreet via native package manager instead:"
                if command -v apt >/dev/null 2>&1; then
                  echo "   sudo apt install greetd-tuigreet"
                elif command -v dnf >/dev/null 2>&1; then
                  echo "   sudo dnf install greetd-tuigreet"
                elif command -v pacman >/dev/null 2>&1; then
                  echo "   sudo pacman -S greetd-tuigreet"
                else
                  echo "   Install greetd-tuigreet via your package manager"
                fi
                echo ""
                
                # Check if greetd is system-installed (common case)
                if command -v greetd >/dev/null 2>&1; then
                  greetd_path="$(command -v greetd)"
                  if ! echo "$greetd_path" | grep -q "/nix/store"; then
                    echo "[!] Mixed installation detected:"
                    echo "   • greetd: system package ($greetd_path)"
                    echo "   • tuigreet: Nix package ($tuigreet_path)"
                    echo "   This often causes authentication failures!"
                    echo ""
                  fi
                fi
              else
                echo "[✓] tuigreet installed via native package manager"
                echo "   This is the recommended approach for compatibility"
              fi
              
              # Test tuigreet can run
              if tuigreet --help >/dev/null 2>&1; then
                echo "[✓] tuigreet can execute"
              else
                echo "[✗] tuigreet fails to run - check dependencies"
                if command -v ldd >/dev/null 2>&1; then
                  echo "   Debug with: ldd $tuigreet_path"
                fi
              fi
            else
              echo "[✗] tuigreet not found in PATH"
              echo ""
              echo "   INSTALL VIA NATIVE PACKAGE MANAGER (recommended):"
              if command -v apt >/dev/null 2>&1; then
                echo "   sudo apt install greetd-tuigreet"
              elif command -v dnf >/dev/null 2>&1; then
                echo "   sudo dnf install greetd-tuigreet"
              elif command -v pacman >/dev/null 2>&1; then
                echo "   sudo pacman -S greetd-tuigreet"
              else
                echo "   Install greetd-tuigreet via your package manager"
              fi
              echo ""
              echo "   FALLBACK (Nix - may have compatibility issues):"
              echo "   nix profile install nixpkgs#greetd.tuigreet"
              echo "   Then use absolute path in greetd config"
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
                
                # Check if tuigreet path in config is valid
                tuigreet_in_config=$(grep "tuigreet" /etc/greetd/config.toml | head -1)
                echo "   Config: $tuigreet_in_config"
                
                # Extract and validate tuigreet path in config
                if echo "$tuigreet_in_config" | grep -q "command.*=.*tuigreet"; then
                  # Extract the tuigreet path from config
                  config_tuigreet_path=$(echo "$tuigreet_in_config" | sed -n 's/.*command.*=.*"\([^"]*tuigreet[^"]*\)".*/\1/p' | awk '{print $1}')
                  
                  if [[ -n "$config_tuigreet_path" ]]; then
                    if [[ -x "$config_tuigreet_path" ]]; then
                      echo "[✓] tuigreet path in config is executable: $config_tuigreet_path"
                    else
                      echo "[!] tuigreet path in config not found/executable: $config_tuigreet_path"
                      current_tuigreet="$(command -v tuigreet 2>/dev/null)"
                      if [[ -n "$current_tuigreet" ]]; then
                        echo "   Current tuigreet path: $current_tuigreet"
                        echo "   Update config to use: $current_tuigreet"
                      fi
                    fi
                  fi
                fi
              else
                echo "[!] greetd config doesn't reference tuigreet"
                echo "   Update config to use: command = \"tuigreet --cmd Hyprland\""
              fi
            else
              echo "[!] greetd config missing"
              echo "   Example config available at: ~/.config/tuigreet/example-greetd-config.toml"
              echo "   Copy it: sudo cp ~/.config/tuigreet/example-greetd-config.toml /etc/greetd/config.toml"
              echo ""
              echo "   Note: The example config uses Nix paths. For system packages, edit the path:"
              if command -v tuigreet >/dev/null 2>&1; then
                current_tuigreet="$(command -v tuigreet)"
                echo "   Replace tuigreet path with: $current_tuigreet"
              fi
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
            
            # Check greetd socket
            echo ""
            echo "=== Socket Check ==="
            if systemctl is-active greetd >/dev/null 2>&1; then
              # Look for greetd socket in common locations
              socket_found=false
              for sock_path in "/run/greetd.sock" "/var/run/greetd.sock" "/tmp/greetd.sock"; do
                if [[ -S "$sock_path" ]]; then
                  echo "[✓] greetd socket found: $sock_path"
                  socket_perms=$(ls -l "$sock_path" 2>/dev/null)
                  echo "   Permissions: $socket_perms"
                  socket_found=true
                  break
                fi
              done
              
              if [[ "$socket_found" == "false" ]]; then
                echo "[!] greetd socket not found in common locations"
                echo "   greetd may not be fully started yet"
                echo "   Check: sudo find /run /var/run /tmp -name '*greetd*' -type s 2>/dev/null"
              fi
            else
              echo "[!] greetd not running - socket won't exist"
              echo "   Start greetd: sudo systemctl start greetd"
            fi
            
            # Check if other display managers are still active
            for dm in gdm sddm lightdm; do
              if systemctl is-active "$dm" >/dev/null 2>&1; then
                echo "[!] $dm is still running - this will conflict with greetd"
                echo "   Disable it: sudo systemctl disable --now $dm"
              fi
            done
            
            # Check VT availability and permissions
            echo ""
            echo "=== VT Permission Check ==="
            for vt in 7 1 2; do
              if [[ -c /dev/tty$vt ]]; then
                vt_perms=$(ls -l /dev/tty$vt 2>/dev/null)
                echo "[i] VT$vt: $vt_perms"
                
                # Check if greetd user can access the VT
                if [[ -c /dev/tty$vt ]]; then
                  if ls -l /dev/tty$vt | grep -q "crw-rw----.*tty"; then
                    echo "[✓] VT$vt has correct permissions (rw-rw----)"
                  else
                    echo "[!] VT$vt permissions may be incorrect"
                    echo "   Should be: crw-rw---- root tty"
                    echo "   Current: $vt_perms"
                  fi
                  
                  # Check if greetd user is in tty group
                  if id greetd >/dev/null 2>&1; then
                    if groups greetd 2>/dev/null | grep -q "tty"; then
                      echo "[✓] greetd user is in tty group"
                    else
                      echo "[!] greetd user not in tty group"
                      echo "   Add to tty group: sudo usermod -a -G tty greetd"
                    fi
                  fi
                fi
              else
                echo "[!] VT$vt not available"
              fi
            done
            
            # Check environment and dependencies
            echo ""
            echo "=== Environment Check ==="
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
            
            # Check for common tuigreet dependencies
            echo ""
            echo "=== Dependency Check ==="
            if command -v tuigreet >/dev/null 2>&1; then
              tuigreet_path="$(command -v tuigreet)"
              if command -v ldd >/dev/null 2>&1; then
                echo "[i] Checking tuigreet dependencies:"
                if ldd "$tuigreet_path" >/dev/null 2>&1; then
                  echo "[✓] tuigreet dependencies look good"
                  # Show any missing dependencies
                  if ldd "$tuigreet_path" 2>&1 | grep -q "not found"; then
                    echo "[!] Missing dependencies:"
                    ldd "$tuigreet_path" 2>&1 | grep "not found"
                  fi
                else
                  echo "[!] Could not check dependencies with ldd"
                fi
              else
                echo "[i] ldd not available - skipping dependency check"
              fi
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
            echo "=== Testing tuigreet ==="
            echo "[i] Note: tuigreet requires greetd to be running"
            echo "Direct testing outside greetd will show 'GREETD_SOCK must be defined'"
            echo ""
            echo "Safe tests:"
            echo "  tuigreet --help  # Show help (works without greetd)"
            echo "  sudo systemctl status greetd  # Check if greetd is running"
            echo "  sudo journalctl -u greetd --no-pager -n 20  # Check greetd logs"
            echo ""
            echo "=== Troubleshooting ==="
            echo "If greetd starts but tuigreet doesn't work:"
            echo "1. Check greetd logs: sudo journalctl -u greetd -f"
            echo "2. Test greetd config: sudo greetd --config /etc/greetd/config.toml --check"
            echo "3. Check VT permissions: ls -la /dev/tty7"
            echo "4. Verify no other DM running: ps aux | grep -E '(gdm|sddm|lightdm)'"
            echo "5. Check library dependencies (if ldd available): ldd \$(command -v tuigreet)"
            echo ""
            echo "For GREETD_SOCK errors (common with mixed package sources):"
            echo "• SOLUTION: Use native packages for both greetd and tuigreet:"
            if command -v apt >/dev/null 2>&1; then
              echo "  sudo apt install greetd greetd-tuigreet"
            elif command -v dnf >/dev/null 2>&1; then
              echo "  sudo dnf install greetd greetd-tuigreet"
            elif command -v pacman >/dev/null 2>&1; then
              echo "  sudo pacman -S greetd greetd-tuigreet"
            else
              echo "  Install both via your native package manager"
            fi
            echo "• Avoid mixing Nix and system packages for display manager components"
            echo "• Verify config uses correct tuigreet path: which tuigreet"
          '';
          executable = true;
        };
      }
    ];
    
    # Activation message
    home.activation.tuigreetSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
      echo "[✓] tuigreet configuration generated!"
      echo ""
      echo "=== IMPORTANT: Use Native Package Manager ==="
      echo "For best compatibility, install greetd and tuigreet via your system's"
      echo "native package manager (apt/dnf/pacman), NOT via Nix."
      echo ""
      echo "=== Next Steps ==="
      echo "1. Install native packages (recommended):"
      if command -v apt >/dev/null 2>&1; then
        echo "   sudo apt install greetd greetd-tuigreet"
      elif command -v dnf >/dev/null 2>&1; then
        echo "   sudo dnf copr enable peterwu/greetd && sudo dnf install greetd greetd-tuigreet"
      elif command -v pacman >/dev/null 2>&1; then
        echo "   sudo pacman -S greetd greetd-tuigreet"
      else
        echo "   Install greetd and greetd-tuigreet via your package manager"
      fi
      echo ""
      echo "2. Run setup helper as regular user:"
      echo "   ~/.local/bin/setup-tuigreet"
      echo "   (Will guide installation and configuration)"
      echo ""
      echo "3. Configuration files created:"
      echo "   • Example greetd config: ~/.config/tuigreet/example-greetd-config.toml"
      echo "   • Theme config: ~/.config/tuigreet/theme.toml"
      echo "   • Setup helper: ~/.local/bin/setup-tuigreet"
    '';
  };
}