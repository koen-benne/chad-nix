Install:

## NixOS/Darwin (Full System)
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake github:koen-benne/chad-nix
```

## Home Manager Only
For environments where you only want to manage user configuration without system-level changes:

```bash
# Install Nix and Home Manager
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
nix --extra-experimental-features "nix-command flakes" run home-manager/release-25.05 -- switch --flake github:koen-benne/chad-nix#koen@nixos
```

Available home configurations:
- `koen@nixos` - Linux desktop environment
- `koen@nixos-work` - Linux work environment  
- `koen@work-mac` - macOS work environment
- `koen@music-mac` - macOS music/media environment

Replace `koen@nixos` with the appropriate configuration for your system.


Todo:
- manage certificates
- when an app has a home manager and non-home manager module, the enable option should only be in home manager, rather than having to enable the home manager module from within the non-home manager module
- use sys instead of making separate options for hm when they are already in the nixos/darwin config
- make stylix always enabled, as it is impossible to manage optionally
