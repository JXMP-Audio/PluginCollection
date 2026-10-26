#!/usr/bin/env bash
# Bump every plugin submodule to the latest commit of its tracked branch
# (see `branch =` in .gitmodules) and commit the new pointers.
set -euo pipefail
cd "$(dirname "$0")"

git submodule sync --quiet
git submodule update --init --remote

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
