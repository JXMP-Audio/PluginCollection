# PluginCollection

Umbrella repo for JXMP Audio VST/instrument plugins. Each plugin is a separate GitHub repo
(`git@github.com:JXMP-Audio/<Name>.git`) added here as a git submodule tracking `main`.

## Rules

- **Always keep the collection on the newest plugin versions.** Whenever work is committed and
  pushed in a plugin repo (e.g. `JX808/`), immediately bump its submodule pointer here: run
  `./update-plugins.sh` (or `git submodule update --remote <Name>`), commit in this repo, and push.
  Push the plugin repo first, so the pointer never references a commit missing on GitHub.
  Before starting work, run `./update-plugins.sh` to pick up changes made elsewhere.
- This applies to every plugin, current and future. New plugins are added with
  `git submodule add -b main <url> <Name>` and get a row in the README.md plugin table.
- Keep README.md's plugin table in sync with the submodules (name, type, short description, repo link).
- Plugin code changes belong in the plugin repo, never in this repo.
- Keep a handoff file per plugin under active work (PatchCore: `PatchCore/research_docs/STATUS.md`: done /
  in progress / next). Update, commit and push it before a session or usage limit ends; read it first when
  resuming. Unfinished work lives on a pushed branch.
- The website is `web/index.html` (static, CZ / EN). When a plugin is added or changes a lot, update its card in
  the `PLUGINS` list there. Plugin pictures come from the plugin repo (`docs/screenshots/`).
