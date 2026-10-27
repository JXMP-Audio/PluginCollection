#!/usr/bin/env bash
# Compiles an exported plugin project in an older distro container (podman), so the binary
# also runs on systems with an older glibc than the build machine (e.g. Fedora 44 host vs the
# Arch dev container). The project must be exported first: EXPORT_ONLY=1 ./build.sh vst3
#
#   ./build-portable.sh TR808 VST3        -> TR808/build/VST3-portable/.../build/TR808.vst3
#
# Runs on the host (or anywhere with podman). Override the image with IMAGE=... and the number of
# compile jobs with JOBS=... (default: half the cores; HISE units need about 1.5 GB each).
set -euo pipefail
cd "$(dirname "$0")"
ROOT="$(pwd)"
PLUGIN="${1:?plugin folder, e.g. TR808}"
TARGET="${2:-VST3}"
IMAGE="${IMAGE:-quay.io/fedora/fedora:43}"
JOBS="${JOBS:-$(( ($(nproc) + 1) / 2 ))}"
SRC="$PLUGIN/build/$TARGET"
DEST="$PLUGIN/build/$TARGET-portable"

[ -f "$SRC/Builds/LinuxMakefile/Makefile" ] || { echo "export $PLUGIN first (EXPORT_ONLY=1 ./build.sh)" >&2; exit 1; }
rsync -r -c --delete --exclude /Builds/LinuxMakefile/build "$SRC/" "$DEST/"

podman run --rm --security-opt label=disable -e JOBS="$JOBS" -v "$ROOT:$ROOT" -w "$ROOT/$DEST/Builds/LinuxMakefile" "$IMAGE" bash -c '
  set -e
  dnf install -y -q gcc-c++ make pkgconf-pkg-config alsa-lib-devel freetype-devel libX11-devel libXinerama-devel \
    libXext-devel libXrandr-devel libXcursor-devel libcurl-devel mesa-libGL-devel gtk3-devel \
    pipewire-jack-audio-connection-kit-devel >/dev/null
  make CONFIG=Release AR=gcc-ar CPPFLAGS=-DJUCE_USE_CURL=0 -j"$JOBS"'
find "$DEST/Builds/LinuxMakefile/build" -maxdepth 1 -name "*.vst3" -o -maxdepth 1 -type f -perm -u+x
