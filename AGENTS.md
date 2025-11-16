# AGENTS.md - NixOS/Darwin Configuration

## Important Restrictions
- **Never switch configurations**: Do not run `nixos-rebuild switch`, `home-manager switch`, or similar commands. The user will handle all configuration switching.

## Build/Lint/Test Commands
- `nix flake check --all-systems --no-build` - Check flake structure and syntax
- `nix develop --command format` - Format all Nix files with alejandra
- `nix develop --command check` - Run full flake check
- `git ls-files '*.nix' | xargs nix develop --command alejandra --check` - Check formatting
- `nix build .#nixosConfigurations.<hostname>` - Build specific host configuration
- `nix develop` - Enter development shell with formatting tools

## Code Style Guidelines
- **Language**: Nix expressions with some TypeScript for plugins
- **Formatting**: Use alejandra formatter for all .nix files (2-space indentation)
- **Imports**: Follow `{ inputs, config, lib, pkgs, ... }:` pattern consistently
- **Module Structure**: Use `lib.my.getModules [./.]` for automatic module discovery
- **Options**: Define with `mkEnableOption (mdDoc "description")` pattern
- **Config Guards**: Wrap config in `mkIf cfg.enable` blocks
- **Naming**: Use `my.<module>` namespace for custom options (e.g., `my.desktop.enable`)
- **Comments**: Use `# TODO:` for known issues, minimal inline comments
- **File Organization**: Separate `default.nix` (system) and `home.nix` (user) configs
- **Secrets**: Use sops-nix with proper ownership/permissions (mode "0400")

## Home-Manager Compatibility Architecture (Linux Only)

### Module Structure Pattern
For modules that need standalone home-manager support on Linux systems:
```
modules/{common,nixos}/<module>/
├── default.nix      # System-level configuration (NixOS only)
├── home.nix         # User-level configuration (works everywhere)
└── compat.nix       # Option definitions for home-manager-only mode
```

### Usage Modes
1. **NixOS System**: Uses `default.nix` (defines options) + `home.nix` (uses sys.* options)
2. **Home-Manager Standalone**: Uses `compat.nix` (defines options) + `home.nix` (uses sys.* options)

### Discovery Functions
- `lib.my.getModules [./.]` - Discovers `default.nix` files (system mode)
- `lib.my.getCompatModules [./.]` - Discovers `compat.nix` files (home-manager-only mode)
- `lib.my.getHmModules [./.]` - Discovers `home.nix` files (both modes)

### Implementation Rules
- **compat.nix**: Only define `options.my.*` - no system-level config
- **Darwin**: No compat.nix needed (no standalone home-manager support)
- **Auto-Discovery**: home-manager-compat uses `getCompatModules` for automatic discovery
- **Selective**: Only modules requiring system options need `compat.nix`