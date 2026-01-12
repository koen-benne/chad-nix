# gtklock-unwired

A special gtklock configuration module inspired by [unwiredfromreality's dots-and-stuff](https://github.com/unwiredfromreality/dots-and-stuff/).

## Features

- Clean, minimalist lockscreen design
- Media player controls via `gtklock-playerctl-module`
- Uses your existing wallpaper from `assets/wp-normal.jpg`
- Uses system-installed gtklock (via apt), not Nix package
- Only gtklock modules are installed via Nix
- Automatically enabled when `my.dankmaterialshell.enable = true`
- Highly customizable via module options

## Usage

Automatically enabled via dankmaterialshell:

```nix
my.dankmaterialshell.enable = true;  # Automatically enables gtklock-unwired
```

Or enable standalone:

```nix
my.gtklock-unwired.enable = true;
```

**Note:** You must install gtklock via apt first: `sudo apt install gtklock`

## Configuration Options

```nix
my.gtklock-unwired = {
  enable = true;

  # Wallpaper (default: assets/wp-normal.jpg)
  wallpaper = ./path/to/wallpaper.jpg;

  # Font settings (Libre Baskerville style from unwiredfromreality)
  fontFace = "Libre Baskerville";
  fontColor = "#f2e5bc";

  # Background color for playerctl module
  backgroundColor = "#f2e5bc";

  # Additional gtklock modules
  modules = with pkgs; [
    gtklock-playerctl-module
    # gtklock-userinfo-module
    # gtklock-powerbar-module
  ];
};
```

## Integration with DankMaterialShell

When both `my.dankmaterialshell.enable` and `my.gtklock-unwired.enable` are true, the gtklock-unwired lockscreen will automatically be used for DMS lock and suspend actions.

## Lock Scripts

The module creates two scripts:
- `~/.config/gtklock-unwired/lock.sh` - Lock the screen
- `~/.config/gtklock-unwired/lock-and-suspend.sh` - Lock and suspend

You can bind these to keyboard shortcuts in your window manager.

## Credits

Configuration inspired by [unwiredfromreality's dots-and-stuff](https://github.com/unwiredfromreality/dots-and-stuff/).
