# chad-nix

Personal Linux configuration managed with Nix flakes. It supports:

- NixOS with Home Manager integrated into the system configuration.
- Standalone Home Manager on non-NixOS Linux.

## Outputs and architecture

`flake.nix` defines the inputs and supported systems, then imports the active
flake parts. The authoritative output definitions are:

- `parts/nixos.nix` — `nixosConfigurations`.
- `parts/home-manager.nix` — `homeConfigurations`.

Read those files to see which host entrypoints are active. To enumerate their
output names without relying on a stale host list, run:

```bash
nix --option allow-import-from-derivation false eval --json .#nixosConfigurations --apply builtins.attrNames
nix --option allow-import-from-derivation false eval --json .#homeConfigurations --apply builtins.attrNames
```

Host directories that are not referenced by those parts are not active outputs.

The module entrypoints are `modules/nixos.nix`, `modules/home.nix`, and
`modules/home-manager-standalone.nix`. Features are organized as optional
`modules/<feature>/{default.nix,home.nix,compat.nix}` files: system options and
configuration, shared user configuration, and standalone compatibility
respectively. Shared home modules read feature state through `sys`; integrated
mode supplies the NixOS configuration, while standalone mode aliases the Home
Manager configuration. Standalone-only `compat.nix` files declare options
needed by shared home modules and may provide replacement Home Manager config,
but never NixOS-only config. The standalone entrypoint also owns generic Linux
GPU integration.

## Usage

Run these from the repository root, replacing placeholders with names from the
output-listing commands above:

```bash
# NixOS: switch the system output
sudo nixos-rebuild switch --flake .#<nixos-configuration>

# NixOS: build the system toplevel output without switching
nix build .#nixosConfigurations.<nixos-configuration>.config.system.build.toplevel

# Standalone Home Manager: activate the Home Manager output
home-manager switch --flake .#<home-configuration>

# Standalone Home Manager: build its activation package without activating
nix build .#homeConfigurations.<home-configuration>.activationPackage
```

The NixOS commands target a system toplevel; the standalone commands target a
Home Manager activation package. For installation and prerequisite setup, see
the [official Nix documentation](https://nixos.org/manual/nix/) and the
[Home Manager manual](https://nix-community.github.io/home-manager/).

## Development

For human contributors, the development shell provides a flake-check helper
that skips output builds but may realize the development shell and IFD inputs:

```bash
nix develop --command check
git diff --check
```

`nix develop --command check` runs
`nix flake check --all-systems --no-build`. It validates recognized flake and
NixOS outputs, but does not validate arbitrary standalone Home Manager outputs.
Its script does not disable import-from-derivation and may build during
evaluation; agents must not use it under the no-build policy. The agent-safe
form is:

```bash
nix --option allow-import-from-derivation false flake check --all-systems --no-build
```

`--no-build` alone only skips output builds; it does not prevent evaluation-time
IFD. If the IFD-disabled command errors, evaluation is incomplete and a human
must run the ordinary evaluation or build.

Instantiate a standalone Home Manager activation derivation without building
its output:

```bash
# Evaluation only; does not build the activation package.
nix --option allow-import-from-derivation false eval --raw .#homeConfigurations.<home-configuration>.activationPackage.drvPath
# Human-run output build.
nix build .#homeConfigurations.<home-configuration>.activationPackage
```

The first command is evaluation only; the second is the human-run build.
Git-backed flake evaluations and the dev shell see only tracked files, so new
untracked Nix files are not included and feature discovery has not been tested
until the intended files are tracked. Format and parse new files directly, then
ask a human to rerun flake evaluation after tracking them. Do not stage files
just for validation.

```bash
# Review this filename list first.
git ls-files --cached --others --exclude-standard -- '*.nix'
```

If any secret-bearing path appears, do not run the bulk pipelines; pass only
explicitly reviewed safe paths to the formatter and parser instead.

When `alejandra` is already available in `PATH`, use these direct checks:

```bash
git ls-files -z --cached --others --exclude-standard -- '*.nix' |
  xargs -0 -r alejandra --check
git ls-files -z --cached --others --exclude-standard -- '*.nix' |
  xargs -0 -r -n1 nix-instantiate --parse >/dev/null
```

If it is unavailable, human contributors may enter `nix develop` to obtain the
formatter; agents must not invoke a development environment for validation.

Human contributors should build affected NixOS toplevels or Home Manager
activation packages before activating them.
