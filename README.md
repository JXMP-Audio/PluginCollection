# JXMP Audio — Plugin Collection

A collection of JXMP Audio virtual instruments and effects. Each plugin lives in its own
repository and is included here as a git submodule, always pointing at its latest version.

## Plugins

| Plugin | Type | Description | Repository |
| --- | --- | --- | --- |
| [TR808](TR808/) | Instrument (HISE) | Roland TR-808 Rhythm Composer recreation with MIDI drum programming and an 808-bass pitch mode. | [JXMP-Audio/TR808](https://github.com/JXMP-Audio/TR808) |

## Getting the code

```sh
git clone --recurse-submodules git@github.com:JXMP-Audio/PluginCollection.git
```

Already cloned without submodules:

```sh
git submodule update --init
```

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
