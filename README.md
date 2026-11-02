# JXMP Audio — Plugin Collection

A collection of JXMP Audio virtual instruments and effects. Each plugin lives in its own repository and is
included here as a git submodule, always pointing at its latest version. The JXMP Audio website is in `web/`.

## Plugins

| Plugin | Type | Description | Repository |
| --- | --- | --- | --- |
| [JX808](JX808/) | Instrument (HISE) | Rhythm Machine JX-808, an analogue-modelled vintage drum machine: hardware-style panel, DAW sync, MIDI programming and drag & drop, preset cartridges, 808-bass pitch mode. | [JXMP-Audio/JX808](https://github.com/JXMP-Audio/JX808) |
| [PatchCore](PatchCore/) | Modular synthesizer | A modular synthesizer laid out like a studio rack: basic modules on the front, 25+ JXMP modules on the back, six interactive lessons; standalone and VST3 for Linux and Windows. | [JXMP-Audio/PatchCore](https://github.com/JXMP-Audio/PatchCore) |

## Getting the code

```sh
git clone --recurse-submodules git@github.com:JXMP-Audio/PluginCollection.git
```

Already cloned without submodules:

```sh
git submodule update --init --recursive
```

How to build and use each plugin is in that plugin's own README.
