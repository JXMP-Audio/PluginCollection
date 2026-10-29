# JXMP Audio — Plugin Collection

A collection of JXMP Audio virtual instruments and effects. Each plugin lives in its own
repository and is included here as a git submodule, always pointing at its latest version.

## Plugins

| Plugin | Type | Description | Repository |
| --- | --- | --- | --- |
| [JX808](JX808/) | Instrument (HISE) | Rhythm Machine JX-808, an analogue-modelled vintage drum machine: hardware-style panel, DAW sync, MIDI programming and drag & drop, preset cartridges, 808-bass pitch mode. | [JXMP-Audio/JX808](https://github.com/JXMP-Audio/JX808) |
| [PatchCore](PatchCore/) | Modular host (Cardinal fork) | A modular synthesizer plugin based on DISTRHO Cardinal, laid out like a hardware rack: basic modules patch on the front, JXMP modules (VCO, VCF, VCA, ADSR, Patchbay) on the back. | [JXMP-Audio/PatchCore](https://github.com/JXMP-Audio/PatchCore) |

## What is in this folder

| Path | In git | What it is |
|---|---|---|
| `JX808/` | submodule | the JX808 plugin repository ([its README](JX808/README.md)) |
| `PatchCore/` | submodule | the PatchCore repository, a DISTRHO Cardinal fork with its own nested submodules (Rack, DPF, Carla, third-party modules). Clone with `--recurse-submodules` ([its README](PatchCore/README.md)) |
| `hise-patches/` | yes | our patches to HISE 4.1.0, applied by `setup-hise.sh` |
| `setup-hise.sh` | yes | downloads / unpacks HISE into `HISE/` and applies the patches |
| `build-portable.sh` | yes | compiles an exported plugin in a Fedora 43 container (binary for older glibc) |
| `update-plugins.sh` | yes | bumps every submodule to the newest commit of its `main` |
| `web/` | yes | the JXMP Audio website: `index.html` (one page, CZ / EN) and the logo. Plugin cards are the `PLUGINS` list in the script; JX808's picture comes from `JX808/docs/screenshots/` on GitHub |
| `CLAUDE.md` | yes | working rules for this repository |
| `HISE/` | no (ignored) | local HISE: `HISE Standalone` (export tool, 40 MB) and `source/` (HISE + JUCE source with the patches, needed to compile plugins). Recreate with `./setup-hise.sh` |
| `<Plugin>/build/` | no (ignored) | that plugin's build output, see its README |

Inside a HISE project HISE also creates empty standard folders (`AudioFiles`, `Documentation`,
`Expansions`, `MidiFiles`, `Presets`, `SampleMaps`, `Samples`) and `Binaries/`, `PooledResources/`
every time it loads or exports the project. They aren't in git and can be ignored.

## Getting the code

```sh
git clone --recurse-submodules git@github.com:JXMP-Audio/PluginCollection.git
```

Already cloned without submodules:

```sh
git submodule update --init --recursive
```

## Building plugins (HISE)

The plugins are HISE projects. Every plugin's `build.sh` uses the local HISE in `HISE/` (git-ignored):

```sh
./setup-hise.sh [path/to/HISE.4.1.0.debian.x64.zip]   # binary + 4.1.0 source + SDK + patches
cd JX808 && ./build.sh standalone                       # or: vst3, all
```

`hise-patches/` holds our changes to HISE:

| Patch | What it does |
|---|---|
| 0001 resizable-frontend | Plugin and standalone windows resize freely and scale the interface |
| 0002 hardcoded-fx-state-after-set-effect | Presets and DAW sessions keep the node state (parameters, pattern memory) |
| 0003 midi-out-for-hardcoded-nodes | Hardcoded nodes can send MIDI to the plugin output |
| 0004 juce-no-xsettings-manager | JUCE no longer crashes hosts on window managers without XSETTINGS (Hyprland, Sway, i3) |

Every plugin repo with a release workflow keeps a copy in `.github/hise-patches/`.

`./build-portable.sh <Plugin> VST3` compiles an exported project (`EXPORT_ONLY=1 ./build.sh vst3`) in a
Fedora 43 container with podman, so the binary also runs on a host with an older glibc than the dev container.

Re-run `./setup-hise.sh` after adding a patch. It skips patches
that are already applied.

In the HISE editor, set **File → Settings → Compiler → HISE Path** to `HISE/source`.

## Playing with PatchCore

The launcher lives in the PatchCore repository ([PatchCore/run-patchcore.sh](PatchCore/run-patchcore.sh)).
Started on the host it runs inside the distrobox PatchCore is built in.

```sh
PatchCore/run-patchcore.sh demo        # JXMP ambient patch (builds PatchCore first if needed)
PatchCore/run-patchcore.sh             # empty rack
PatchCore/run-patchcore.sh --install   # add PatchCore to the application menu
```

Right-click on the rack (or Enter) opens the module finder: type to search, `@brand` and
`#purpose` filter (e.g. `vco@jxmp`). `Tab` turns the rack around to patch the JXMP modules
on the back. The mouse wheel turns knobs. Right-click on a module selects it (then `Delete`
removes it), Ctrl+right-click opens its menu.

## Keeping plugins up to date

Every submodule tracks the `main` branch of its repository (`branch = main` in `.gitmodules`).
To bump all plugins to their latest commit and record that in this repository:

```sh
./update-plugins.sh
git push
```

## Adding a new plugin

```sh
git submodule add -b main git@github.com:JXMP-Audio/<Plugin>.git <Plugin>
```

Then add a row to the table above and commit.

Build instructions for each plugin are in that plugin's own README.
