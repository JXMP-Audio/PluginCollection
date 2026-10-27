# JXMP Audio — Plugin Collection

A collection of JXMP Audio virtual instruments and effects. Each plugin lives in its own
repository and is included here as a git submodule, always pointing at its latest version.

## Plugins

| Plugin | Type | Description | Repository |
| --- | --- | --- | --- |
| [TR808](TR808/) | Instrument (HISE) | TR-808 Rhythm Composer recreation (JX-808): original panel, DAW sync, MIDI programming and drag & drop, preset cartridges, 808-bass pitch mode. | [JXMP-Audio/TR808](https://github.com/JXMP-Audio/TR808) |

## Getting the code

```sh
git clone --recurse-submodules git@github.com:JXMP-Audio/PluginCollection.git
```

Already cloned without submodules:

```sh
git submodule update --init
```

## Building plugins (HISE)

The plugins are HISE projects. Every plugin's `build.sh` uses the local HISE in `HISE/` (git-ignored):

```sh
./setup-hise.sh [path/to/HISE.4.1.0.debian.x64.zip]   # binary + 4.1.0 source + SDK + patches
cd TR808 && ./build.sh standalone                       # or: vst3, all
```

`hise-patches/` holds our changes to HISE. The patch `0001-resizable-frontend.patch` lets the
plugin and standalone windows be resized freely: the interface keeps its aspect ratio, scales to
the window, and remembers the size. The patches:

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
