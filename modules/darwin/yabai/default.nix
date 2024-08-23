{
  config,
  lib,
  pkgs,
  ...
}: let
  scripts = ./scripts;
in {
  # csrutil enable --without fs --without debug --without nvram
  # nvram boot-args=-arm64e_preview_abi
  environment.etc."sudoers.d/yabai".text = ''
    ${config.my.user} ALL = (root) NOPASSWD: ${pkgs.yabai}/bin/yabai --load-sa
  '';

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    config = {
      # layout
      layout = "bsp";
      auto_balance = "off";
      split_ratio = "0.50";
      window_placement = "second_child";
      # Gaps
      window_gap = 06;
      # top_padding = 52;
      top_padding = 12;
      bottom_padding = 12;
      left_padding = 12;
      right_padding = 12;
      # shadows and borders
      window_shadow = "float";
      # mouse
      mouse_follows_focus = "off";
      focus_follows_mouse = "off";
      mouse_modifier = "cmd";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      mouse_drop_action = "swap";
    };
    extraConfig = ''
      # Unload the macOS WindowManager process
      launchctl unload -F /System/Library/LaunchAgents/com.apple.WindowManager.plist > /dev/null 2>&1 &
      # bar
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
      yabai -m signal --add event=display_added action="sleep 1 && ${scripts}/setup_spaces.sh"
      yabai -m signal --add event=display_removed action="sleep 1 && ${scripts}/setup_spaces.sh"
      ${scripts}/setup_spaces.sh
      # rules
      yabai -m rule --add app="^(LuLu|Vimac|Calculator|Software Update|Dictionary|VLC|System Preferences|zoom.us|Photo Booth|Archive Utility|Python|LibreOffice|App Store|Steam|Alfred|Activity Monitor)$" manage=off
      yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
      yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
      yabai -m rule --add label="About This Mac" app="System Information" title="About This Mac" manage=off
      yabai -m rule --add label="Select file to save to" app="^Inkscape$" title="Select file to save to" manage=off
      yabai -m rule --add label="kittypopup" app="kitty" title="kittypopup" manage=off
      yabai -m rule --add label="Fzf" app="alacritty" title="Fzf" manage=off
    '';
  };

  launchd.user.agents.yabai.serviceConfig.EnvironmentVariables.PATH =
    lib.mkForce "${config.services.yabai.package}/bin:${config.my.systemPath}";

  system.defaults.CustomUserPreferences = {
    "com.apple.dock" = {
      # Automatically rearrange Spaces based on most recent use -> [ ]
      mru-spaces = 0;
    };
    "com.apple.WindowManager" = {
      # Show Items -> On Desktop -> [x]
      StandardHideDesktopIcons = 0;
      # Click wallpaper to reveal Desktop -> Only in Stage Manager
      EnableStandardClickToShowDesktop = 0;
    };
  };

  system.activationScripts.preActivation.text = ''
    ${pkgs.sqlite}/bin/sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
      "INSERT or REPLACE INTO access(service,client,client_type,auth_value,auth_reason,auth_version) VALUES('kTCCServiceAccessibility','${pkgs.yabai}/bin/yabai',1,2,4,1);"
  '';
  system.activationScripts.postActivation.text = ''
    ${pkgs.sqlite}/bin/sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
      "DELETE from access where client_type = 1 and client != '${pkgs.yabai}/bin/yabai' and client like '%/bin/yabai';"
  '';
}
