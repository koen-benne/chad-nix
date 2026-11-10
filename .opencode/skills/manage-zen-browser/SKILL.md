---
name: Manage Zen Browser
description: Manage the declarative Zen Browser configuration in modules/nixos/zen-browser/home.nix, including project bundles, spaces, pins, containers, extensions, policies, preferences, search, bookmarks, and compatibility with pinned upstream versions.
---

# Manage Zen Browser

Use this skill for changes to the declarative Zen Browser setup. Its primary
target is `modules/nixos/zen-browser/home.nix`.

## Safety and scope

- Read the nearest `AGENTS.md` files and the relevant surrounding config before
  proposing or making changes. Never inspect secrets or credential files.
- Before editing, record baseline `git status` plus relevant unstaged and staged
  diffs. Preserve all pre-existing staged, unstaged, and untracked work; never
  use destructive Git commands such as reset, restore, checkout, or clean. After
  editing, distinguish the skill's changes from that baseline and report only
  the skill's changed paths.
- Do not edit until you have presented a concise plan and preview and the user
  has explicitly approved it.
- Preserve unrelated settings, stable IDs, positions/order, and relationships.
  Do not silently regenerate IDs, broadly normalize the file, or rewrite
  equivalent structures.
- Do not invent real URLs, names, icons, IDs, or other user-specific data.
  Ask for missing values. New IDs must be unique and valid for the applicable
  schema; inspect upstream option/schema semantics when uncertain.
- A Zen flake input or `flake.lock` update is separate scope. Never update a
  dependency without explicit user approval.
- Never run a build, activation, or configuration switch command. Report only
  checks that were actually run.

## Initial inspection

1. Identify the requested operation and read the relevant sections of the
   primary target, including existing IDs, force flags, ordering, and links
   between resources.
2. Search the repository for references to affected space/workspace, pin,
   container, extension, policy, preference, search engine, or bookmark names
   and IDs. Keep the search focused and do not print secret contents.
3. For compatibility questions, determine the Zen flake's pinned revision from
   the existing flake files first, along with every other relevant pinned input
   (including Home Manager and followed or indirect inputs that may expose the
   module or its options). Identify the likely owner of each option without
   assuming all options come from Zen or all come from Home Manager. Diagnose
   against those locked revisions before considering any upgrade. Consult the
   authoritative upstream source, schema, or documentation corresponding to
   each locked revision when option behavior or compatibility is relevant, not
   merely the current upstream HEAD, and distinguish upstream incompatibility
   from a local configuration error.

## Interactive operations

### Gather requirements

Before proposing a change, collect the minimum concrete details rather than
guessing:

- operation: add, update, or remove;
- project/bundle name and the exact user-supplied URLs or other values;
- affected space/workspace, its existing stable ID or approval to create a new
  ID, icon, theme, and desired position/order;
- pin names, stable IDs, URLs, workspace association, essential status, and
  positions;
- optional container name, stable ID, color, icon, and which resources use it;
- for each extension, the add-on/extension manifest ID used as the
  `ExtensionSettings` key, the separate addons.mozilla.org slug or identifier
  used to construct its install URL, and whether it is forced or toolbar-pinned;
  do not guess or conflate these values, and follow the existing local helper
  style for extension entries;
- policies and preferences, including their intended lock/force behavior;
- search engines, aliases, bookmarks, folders, and ordering where relevant;
- whether an existing resource is shared and must remain after the change.

Treat a **project bundle** as a coordinated, but not necessarily complete,
set of resources: a Zen space, its theme/icon/stable ID, project-specific pins,
and an optional container. Explain which bundle components are actually being
changed; do not infer missing components from the project name.

### Plan and preview

Present a concise preview before editing that includes:

- the target file(s) and exact config paths;
- current-to-proposed changes, including every resource to add, update, or
  remove;
- IDs, positions/order, workspace relationships, and force/policy effects;
- shared resources that will be preserved;
- any upstream compatibility finding and migration impact; and
- checks to run after the edit.

Ask for one explicit approval of this complete preview. If requirements change,
produce a new preview and approval rather than extending the old one silently.

### Applying changes

After approval, make the smallest targeted edit in the established Nix style.
Keep existing labels, IDs, positions, comments, and neighboring settings unless
the approved change requires otherwise. Maintain valid references between
spaces/workspaces, pins, containers, extensions, policies, preferences,
search, and bookmarks. Inspect the actual diff immediately afterward and
confirm it matches the approved preview. Compare status and relevant diffs with
the recorded baseline so pre-existing work remains untouched.

### Removing a project

Removal is a dependency-sensitive operation:

1. Inspect all references to the project's space/workspace ID and label,
   project pins, container IDs, URLs, and related policies/preferences or other
   resources.
2. Preview every affected space, pin, container, and other reference, marking
   shared resources that must be retained and explaining any dangling-reference
   risk.
3. Obtain one explicit approval for the complete cascade before removing
   anything. Do not delete shared resources merely because they are associated
   with the project.
4. Remove only approved project-owned entries and update approved references,
   preserving the remaining IDs, order, and relationships.

## Upstream compatibility maintenance

For an option or schema issue, identify every relevant pinned input and locked
revision first: the Zen input plus Home Manager and any followed or indirect
input that may own or expose the option. Determine ownership per option rather
than assuming it belongs to one project. Consult the authoritative upstream
source, option definitions, schema, release notes, or documentation for each
corresponding locked revision, not merely current HEAD. Summarize the diagnosis,
compatibility or migration impact, and the smallest local change that resolves
it. Do not turn compatibility work into a flake input or lock-file update:
propose that separately and request explicit approval. If the pinned versions
cannot support the requested behavior, stop at the diagnosis and proposal
instead of silently changing dependencies.

## Validation and report

After approved edits, inspect the resulting diff and report changed paths,
preserved or intentionally changed IDs/relationships, and any unresolved
uncertainty. For changed `.nix` paths only, use Alejandra through the
repository's Nix development environment, for example:
`nix develop --command alejandra --check <changed-nix-paths>`. Using `nix
develop` here is permitted solely to enter the declared development
environment and run Alejandra. The forbidden evaluation means NixOS/Home
Manager configuration evaluation or checking; it does not prohibit dev-shell
evaluation required to invoke the formatter.

If Alejandra `--check` fails because of the edit, format only the changed Nix
path(s) through that same environment (or fix them manually), then rerun
`--check`. Never invoke the whole-repository `format` command. If formatting
would alter unrelated pre-existing content or work, do not apply those
unrelated changes; report the limitation instead. Do not format or check the
whole repository. If no applicable repository formatter exists for a changed
file type, say so. The post-edit validation is limited to this formatting check
and diff inspection: do not run flake checks, builds, NixOS/Home Manager
configuration evaluation or checking, activation/switch, or runtime checks.
