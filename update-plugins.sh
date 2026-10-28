#!/usr/bin/env bash
# Bump every plugin submodule to the latest commit of its tracked branch
# (see `branch =` in .gitmodules) and commit the new pointers.
set -euo pipefail
cd "$(dirname "$0")"

git submodule sync --quiet
git submodule update --init --remote
# Nested submodules (e.g. PatchCore's Rack, DPF, modules) follow the commits pinned by the
# plugin repo itself, not their own latest branch, so no --remote here.
git submodule foreach --quiet 'git submodule sync --quiet --recursive && git submodule update --init --recursive'

changed=$(git diff --name-only -- $(git config -f .gitmodules --get-regexp 'submodule\..*\.path' | awk '{print $2}'))
if [ -z "$changed" ]; then
    echo "All plugins are up to date."
    exit 0
fi

msg="chore: update plugins"$'\n'
for path in $changed; do
    msg+=$'\n'"- $path -> $(git -C "$path" log -1 --format='%h %s')"
done
git add $changed
git commit -m "$msg"
echo "$msg"
