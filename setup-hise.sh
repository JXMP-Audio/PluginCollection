#!/usr/bin/env bash
# Prepares the local HISE used by the plugin builds (git-ignored, see .gitignore):
#
#   HISE/HISE Standalone   HISE 4.1.0 binary (from the release zip, path or URL as $1)
#   HISE/source            HISE 4.1.0 source + SDK + our patches (hise-patches/*.patch)
#
#   ./setup-hise.sh [HISE.4.1.0.debian.x64.zip]
set -euo pipefail
cd "$(dirname "$0")"

TAG=4.1.0
ZIP="${1:-https://github.com/christophhart/HISE/releases/download/$TAG/HISE.$TAG.debian.x64.zip}"

mkdir -p HISE

if [ ! -x "HISE/HISE Standalone" ]; then
	if [[ "$ZIP" == http* ]]; then
		curl -L --fail -o HISE/hise.zip "$ZIP"
		ZIP=HISE/hise.zip
	fi
	unzip -o -q "$ZIP" -d HISE
	chmod u+x "HISE/HISE Standalone"
fi

if [ ! -d HISE/source ]; then
	git clone --branch "$TAG" --depth 1 https://github.com/christophhart/HISE.git HISE/source
fi

unzip -o -q HISE/source/tools/SDK/sdk.zip -d HISE/source/tools/SDK
chmod u+x HISE/source/tools/projucer/Projucer

for p in hise-patches/*.patch; do
	if git -C HISE/source apply --reverse --check "../../$p" 2>/dev/null; then
		echo "already applied: $p"
	else
		git -C HISE/source apply "../../$p"
		echo "applied: $p"
	fi
done

echo "HISE ready. In HISE set File -> Settings -> Compiler -> HISE Path to $(pwd)/HISE/source"
