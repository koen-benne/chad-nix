# Agent instructions

This repository is a personal Linux configuration. The supported modes are:

- NixOS with Home Manager integrated into the system configuration.
- Standalone Home Manager on non-NixOS Linux.

Darwin is outside the supported scope.

## Non-negotiable restrictions

- Never run `nixos-rebuild switch`, `home-manager switch`, or any other switch,
  activation, or system-changing command. The human performs activations.
- Never run builds such as `nix build`, `nixos-rebuild build`, or
  `home-manager build`. Ask the human to run required builds and provide their
  output.
- Preserve unrelated staged, unstaged, and untracked work. Do not reset,
  restore, clean, or otherwise discard it.
- Never inspect, decrypt, or print secrets, credentials, or secret-bearing
  files.
- Do not edit generated hardware configuration without the human's explicit
  confirmation.

Do not install dependencies globally or mutate the host toolchain to bypass the
repository's declared environment. Do not run system activation commands.

## Authority and discovery

`flake.nix` defines inputs and supported systems and imports the `parts/`
modules. The active outputs are defined by:

- `parts/nixos.nix` for `nixosConfigurations`.
- `parts/home-manager.nix` for `homeConfigurations`.

When tracing a configuration, start there and inspect only the host entrypoints
referenced by those files. The existence of a directory under `hosts/` does not
make it active.

Enumerate the names declared by those parts with:

```bash
nix --option allow-import-from-derivation false eval --json .#nixosConfigurations --apply builtins.attrNames
nix --option allow-import-from-derivation false eval --json .#homeConfigurations --apply builtins.attrNames
```

The mode entrypoints are:

- `modules/nixos.nix`: NixOS and its integrated Home Manager setup.
- `modules/home.nix`: shared Home Manager configuration.
- `modules/home-manager-standalone.nix`: standalone Home Manager compatibility
  and Linux integration.

Features use the following optional file layout:

```
modules/<feature>/{default.nix,home.nix,compat.nix}
```

`default.nix` is for NixOS options/system configuration, while `home.nix` is
shared user configuration. Shared `home.nix` modules read feature state through
`sys`: integrated mode supplies the NixOS configuration, and standalone mode
aliases the Home Manager configuration. `compat.nix` is imported only in
standalone mode; it declares compatibility options required by shared home
modules and may provide standalone-only Home Manager configuration replacing
NixOS behavior. It must not contain NixOS-only configuration. A feature only
needs the files required by its responsibility.

`lib.my.getModules`, `lib.my.getHmModules`, and `lib.my.getCompatModules` in
`lib/my.nix` scan the immediate feature subdirectories of their supplied root
for the exact filenames `default.nix`, `home.nix`, and `compat.nix`,
respectively. They return existing paths; imported modules are evaluated. Do
not assume that an undisplayed or unused feature is lazy merely because it was
found by discovery.

GPU support for standalone Home Manager is part of
`modules/home-manager-standalone.nix` through the generic Linux target. Keep
that integration there rather than adding per-package GPU workarounds.

## Task-to-file routing

| Task | Location |
| --- | --- |
| Inputs, systems, and imported flake parts | `flake.nix` |
| Active NixOS outputs and their host wiring | `parts/nixos.nix`, then its referenced `hosts/<host>/` entrypoint |
| Active standalone HM outputs and their host wiring | `parts/home-manager.nix`, then its referenced host home entrypoint |
| Shared NixOS/HM module composition | `modules/nixos.nix`, `modules/home.nix` |
| Standalone HM compatibility | `modules/home-manager-standalone.nix` and feature `compat.nix` files |
| Feature implementation | `modules/<feature>/default.nix`, `home.nix`, or `compat.nix` as applicable |
| Reusable discovery helpers | `lib/my.nix` |
| Host-specific settings | The active host entrypoint under `hosts/` |
| Generated hardware settings | The active host's `hardware.nix`, only with confirmation |

## Module conventions

- Accept only module arguments that the module needs.
- Use `my.*` for repository feature state; define enable options with
  `mkEnableOption` and guard feature configuration with `mkIf` where
  appropriate. Compatibility modules may declare additional options required
  by shared home modules.
- Import upstream modules from the relevant module and use the repository's
  discovery helpers for local feature modules.
- Enable host-specific features in the active host entrypoint, not by
  duplicating host facts in shared modules.
- Keep volatile facts (versions, package details, and machine-specific values)
  in their authoritative source; do not duplicate them in documentation or
  across modules.
- Keep changes focused and preserve unrelated work.

## Validation

Choose checks based on the files changed:

| Change | Agent-safe checks | Human-only build check |
| --- | --- | --- |
| Documentation or non-Nix metadata | `git diff --check` | None |
| Nix syntax or formatting | `git diff --check`; use direct `alejandra --check` only if `alejandra` is already in `PATH`, plus the parser below | None |
| Flake, parts, modules, or host wiring (parse/no-build evaluation) | `nix --option allow-import-from-derivation false flake check --all-systems --no-build` | Build the affected output below |
| Standalone HM derivation evaluation | `nix --option allow-import-from-derivation false eval --raw .#homeConfigurations.<name>.activationPackage.drvPath` (derivation instantiation, without building the output) | `nix build .#homeConfigurations.<name>.activationPackage` |
| NixOS output behavior | The no-build check above | `nix build .#nixosConfigurations.<name>.config.system.build.toplevel` |

`nix --option allow-import-from-derivation false flake check --all-systems
--no-build` skips output builds and disables evaluation-time IFD. `--no-build`
alone does not prevent IFD. If the IFD-disabled command errors, evaluation is
incomplete; ask the human to run the ordinary evaluation or build. The
`nix develop --command check` helper does not disable IFD and may build during
evaluation, so agents must not use it. It also does not validate arbitrary or
unrecognized `homeConfigurations` outputs; use the direct HM derivation
evaluation above. Git-backed flake evaluations and the dev shell see only
tracked files, so a new feature's discovery and evaluation are incomplete until
its intended files are tracked. Directly parse and format new Nix files, report
the incomplete flake evaluation, and ask the human to rerun evaluation after
the files are tracked. Agents must not stage files merely for validation.

The dev-shell `format` helper uses `./**/*.nix`, which can miss files. First
list and review all tracked and untracked, nonignored Nix filenames:

```bash
git ls-files --cached --others --exclude-standard -- '*.nix'
```

If any secret-bearing path appears, do not run the bulk pipelines. Instead pass
only explicitly reviewed safe paths to the formatter and parser. Otherwise,
these pipelines cover the repository, including overlays, packages, and
documentation. Use the formatter pipeline only when `command -v alejandra`
succeeds; otherwise report formatting validation as unavailable and ask the
human to run it. Do not use `nix develop`, `nix shell`, or another environment
realization as an agent substitute:

```bash
git ls-files -z --cached --others --exclude-standard -- '*.nix' |
  xargs -0 -r alejandra --check
git ls-files -z --cached --others --exclude-standard -- '*.nix' |
  xargs -0 -r -n1 nix-instantiate --parse >/dev/null
```

Use the reviewed path set for both commands. Agents must not run the human-only
build commands. Report them to the human and request the output when needed.
