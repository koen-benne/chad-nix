{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.my.desktop;
  scripts = ./scripts;
in {
  config = mkIf (cfg.windowManager == "aerospace") {
    home.packages = [
      pkgs.unstable.aerospace
    ];

    # home.activation.aerospace = lib.hm.dag.entryAfter ["writeBoundary"] ("open ${inputs.aerospace.packages.aarch64-darwin.default}/AeroSpace.app");
    home.file = {
      ".config/sketchybar".source = ./sketchybar-config;
    };
    home.file = {
      ".config/aerospace/aerospace.toml".text = ''


        # Place a copy of this config to ~/.aerospace.toml
        # After that, you can edit ~/.aerospace.toml to your liking

        # You can use it to add commands that run after login to macOS user session.
        # 'start-at-login' needs to be 'true' for 'after-login-command' to work
        # Available commands: https://nikitabobko.github.io/AeroSpace/commands
        after-login-command = []

        # You can use it to add commands that run after AeroSpace startup.
        # 'after-startup-command' is run after 'after-login-command'
        # Available commands : https://nikitabobko.github.io/AeroSpace/commands
        after-startup-command = [
            # JankyBorders has a built-in detection of already running process,
            # so it won't be run twice on AeroSpace restart
            # 'exec-and-forget ${pkgs.sketchybar}/bin/sketchybar',
            # 'exec-and-forget /opt/homebrew/opt/borders/bin/borders active_color="glow(0xd943ff64)" inactive_color=0x20494d64 width=8.0'
        ]

        exec-on-workspace-change = [
            '/bin/bash',
            '-c',
            '${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change AEROSPACE_FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE AEROSPACE_PREV_WORKSPACE=$AEROSPACE_PREV_WORKSPACE',
        ]

        # Start AeroSpace at login
        start-at-login = true

        # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
        enable-normalization-flatten-containers = false
        enable-normalization-opposite-orientation-for-nested-containers = false

        # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
        # The 'accordion-padding' specifies the size of accordion padding
        # You can set 0 to disable the padding feature
        accordion-padding = 20

        # Possible values: tiles|accordion
        default-root-container-layout = 'tiles'

        # Possible values: horizontal|vertical|auto
        # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
        #               tall monitor (anything higher than wide) gets vertical orientation
        default-root-container-orientation = 'auto'

        # Possible values: (qwerty|dvorak)
        # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
        key-mapping.preset = 'qwerty'

        # Mouse follows focus when focused monitor changes
        # Drop it from your config, if you don't like this behavior
        # See https://nikitabobko.github.io/AeroSpace/guide#on-focus-changed-callbacks
        # See https://nikitabobko.github.io/AeroSpace/commands#move-mouse
        # Fallback value (if you omit the key): on-focused-monitor-changed = []
        on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

        [gaps]
        inner.horizontal = 15
        inner.vertical = 15
        outer.top = 40
        outer.left = 15
        outer.bottom = 15
        outer.right = 15

        # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
        # 'main' binding mode must be always presented
        # Fallback value (if you omit the key): mode.main.binding = {}
        [mode.main.binding]
        cmd-h = [] # Disable "hide application"
        cmd-alt-h = [] # Disable "hide others"

        # All possible keys:
        # - Letters.        a, b, c, ..., z
        # - Numbers.        0, 1, 2, ..., 9
        # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
        # - F-keys.         f1, f2, ..., f20
        # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
        #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
        # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
        #                   keypadMinus, keypadMultiply, keypadPlus
        # - Arrows.         left, down, up, right

        # All possible modifiers: cmd, alt, ctrl, shift

        # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

        alt-enter = ''''exec-and-forget bash -c '
          if ps aux | grep -i "WezTerm" | grep -v "grep" > /dev/null
          then
            ${pkgs.wezterm}/bin/wezterm start --cwd ${config.my.home}
          else
            open ${pkgs.wezterm}/Applications/WezTerm.app
          fi'
        ''''

        alt-w = 'exec-and-forget /Applications/Zen\ Browser.app/Contents/MacOS/zen'

        alt-q = 'close'
        alt-f = 'fullscreen'

        alt-p = 'exec-and-forget bash -c "PATH=${config.my.home}/.nix-profile/bin:$PATH ${pkgs.scripts}/bin/passinator"'
        alt-r = 'exec-and-forget ${pkgs.scripts}/bin/appfzf'

        # See: https://nikitabobko.github.io/AeroSpace/commands#layout
        alt-slash = 'layout tiles horizontal vertical'
        alt-comma = 'layout accordion horizontal vertical'

        # See: https://nikitabobko.github.io/AeroSpace/commands#focus
        alt-shift-h = 'focus left'
        alt-shift-j = 'focus down'
        alt-shift-k = 'focus up'
        alt-shift-l = 'focus right'

        # See: https://nikitabobko.github.io/AeroSpace/commands#move
        # alt-shift-h = 'move left'
        # alt-shift-j = 'move down'
        # alt-shift-k = 'move up'
        # alt-shift-l = 'move right'

        # See: https://nikitabobko.github.io/AeroSpace/commands#resize
        alt-h = 'resize smart -50'
        alt-l = 'resize smart +50'

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
        alt-1 = 'workspace 1'
        alt-2 = 'workspace 2'
        alt-3 = 'workspace 3'
        alt-4 = 'workspace 4'
        alt-5 = 'workspace 5'
        alt-6 = 'workspace 6'
        alt-7 = 'workspace 7'
        alt-8 = 'workspace 8'
        alt-9 = 'workspace 9'

        # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
        alt-shift-1 = 'move-node-to-workspace 1'
        alt-shift-2 = 'move-node-to-workspace 2'
        alt-shift-3 = 'move-node-to-workspace 3'
        alt-shift-4 = 'move-node-to-workspace 4'
        alt-shift-5 = 'move-node-to-workspace 5'
        alt-shift-6 = 'move-node-to-workspace 6'
        alt-shift-7 = 'move-node-to-workspace 7'
        alt-shift-8 = 'move-node-to-workspace 8'
        alt-shift-9 = 'move-node-to-workspace 9'

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
        alt-tab = 'workspace-back-and-forth'
        # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
        alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'

        # See: https://nikitabobko.github.io/AeroSpace/commands#mode
        alt-shift-semicolon = 'mode service'

        # 'service' binding mode declaration.
        # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
        [mode.service.binding]
        esc = ['reload-config', 'mode main']
        r = ['flatten-workspace-tree', 'mode main'] # reset layout
        f = ['layout floating tiling', 'mode main'] # Toggle between floating and tiling layout
        backspace = ['close-all-windows-but-current', 'mode main']

        # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
        #s = ['layout sticky tiling', 'mode main']

        alt-shift-h = ['join-with left', 'mode main']
        alt-shift-j = ['join-with down', 'mode main']
        alt-shift-k = ['join-with up', 'mode main']
        alt-shift-l = ['join-with right', 'mode main']

        [[on-window-detected]]
        if.window-title-regex-substring = 'centered'
        run = 'layout floating'


      '';
    };
  };
}
