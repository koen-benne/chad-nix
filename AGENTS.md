# AGENTS.md - NixOS/Darwin Configuration

## Important Restrictions
- **Never switch configurations**: Do not run `nixos-rebuild switch`, `home-manager switch`, or similar commands. The user will handle all configuration switching.
- **Never run builds directly**: Do not run `nix build`, `home-manager build`, or similar commands yourself. Instead, ask the user to run the build and provide the output. Builds can take a very long time and consume significant resources.

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

## GPU Support for Standalone Home-Manager (Linux Only)

For standalone home-manager on non-NixOS Linux systems, GPU support is provided through home-manager's built-in `targets.genericLinux.gpu` module. This creates a system-level integration that makes GPU acceleration work for all Nix packages automatically.

**Note:** This module is not available in home-manager 25.05, so we import it from `home-manager-unstable`. When upgrading to 25.11+, the import can be removed.

### How It Works

1. **System-Level Integration**: Creates `/run/opengl-driver` symlink pointing to Nix-managed GPU libraries (Mesa, optionally Nvidia)
2. **Systemd Service**: Installs a service that maintains the symlink across reboots
3. **Automatic Notifications**: Home Manager checks and warns you when setup/updates are needed
4. **No Per-Package Wrapping**: Once set up, ALL GUI applications automatically get GPU access

### Setup

The GPU module is automatically enabled in `modules/home-manager-compat/default.nix`:

```nix
config = {
  # Provides XDG dirs, shell integration, terminfo, cursor paths, etc.
  targets.genericLinux.enable = true;
  
  # Enables GPU driver integration (Mesa by default)
  targets.genericLinux.gpu.enable = true;
}
```

### First-Time Setup Process

1. **Install host graphics drivers** first (via your distro's package manager)
2. **Run home-manager switch**:
   ```bash
   home-manager switch
   ```
3. **Home Manager will notify you**:
   ```
   Activating checkExistingGpuDrivers
   This non-NixOS system is not yet set up to use the GPU
   with Nix packages. To set up GPU drivers, run
     sudo /nix/store/HASH-non-nixos-gpu/bin/non-nixos-gpu-setup
   ```
4. **Run the setup command** (requires sudo):
   ```bash
   sudo /nix/store/HASH-non-nixos-gpu/bin/non-nixos-gpu-setup
   ```
5. **All GPU applications now work!** No per-package configuration needed.

### Ongoing Maintenance

- **Automatic updates**: When nixpkgs updates change driver versions, Home Manager will notify you to run the setup command again
- **After reboot**: The systemd service automatically recreates `/run/opengl-driver`
- **Zero maintenance**: Just run the setup command when notified

### Nvidia Support

For Nvidia proprietary drivers, add this configuration (must match host driver version exactly):

```nix
targets.genericLinux.gpu.nvidia = {
  enable = true;
  version = "550.163.01";  # Get from: nvidia-smi
  sha256 = "sha256-...";   # Get from: nix store prefetch-file https://download.nvidia.com/XFree86/Linux-x86_64/VERSION/NVIDIA-Linux-x86_64-VERSION.run
};
```

### Benefits Over Previous nixGL Approach

- ✅ **No per-package wrapping** - Set up once, works everywhere
- ✅ **No library conflicts** - No LD_LIBRARY_PATH pollution
- ✅ **Matches NixOS** - Uses same `/run/opengl-driver` convention
- ✅ **Automatic notifications** - Never forget to update drivers
- ✅ **Cleaner codebase** - Less custom abstraction code
- ✅ **Upstream support** - Maintained by home-manager team

### Package Configuration

No special package wrapping needed! Just use packages normally:

```nix
# Terminal - works automatically
programs.foot.enable = true;

# Browser - works automatically  
programs.zen-browser.enable = true;

# File manager - works automatically
home.packages = [ pkgs.nautilus ];
```

### What targets.genericLinux Also Provides

Beyond GPU support, `targets.genericLinux.enable = true` also provides:

- **XDG data directories** - Adds `/usr/share`, `/usr/local/share`, Nix profile paths
- **Cursor paths** - Sets `XCURSOR_PATH` for system and Nix cursors
- **Shell integration** - Sources `nix.sh` and `hm-session-vars.sh` in bash/zsh/fish
- **Terminfo paths** - Proper terminal database paths for all distros
- **Zsh completions** - Makes system zsh completions available

This eliminates the need for many custom compatibility hacks and provides better integration with the host system.

## Host-Scoped Modules
- Keep custom modules minimal; expose only `my.<module>.enable` by default.
- Add options only for settings that are likely to vary per host (e.g., desktop variant); avoid exposing universal settings (e.g., `openFirewall`)—bake those into module defaults.
- Apply sane defaults internally; tune specifics within the module since we control it.
- Import upstream modules inside our module; rely on `lib.my.getModules [./.]`.
- Enable per host in `hosts/<host>/default.nix`.
- Rely on lazy evaluation so unused modules do not pull dependencies.
- Ensure `inputs` is passed via `specialArgs` so modules can access flake inputs.