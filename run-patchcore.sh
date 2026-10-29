#!/usr/bin/env bash
# Starts the PatchCore standalone (JACK) and connects its first two audio outputs to the default
# PipeWire/PulseAudio output. Under PipeWire the JACK client does not connect itself.
#   ./run-patchcore.sh [patch.vcv]
set -euo pipefail
cd "$(dirname "$0")/PatchCore"
patch="${1:-}"
if [ -n "$patch" ]; then
	PATCHCORE_DEV_PATCH="$(realpath "$patch")" ./bin/Cardinal &
else
	./bin/Cardinal &
fi
pid=$!

# Wait for the JACK ports, then link them to the default sink
sink="$(pactl get-default-sink 2>/dev/null || true)"
for _ in $(seq 50); do
	pw-link -o 2>/dev/null | grep -q '^Cardinal:audio_out_1$' && break
	sleep 0.2
done
if [ -n "$sink" ]; then
	mapfile -t ports < <(pw-link -i | grep "^$sink:playback_" | head -2)
	if [ "${#ports[@]}" -ge 1 ]; then
		pw-link Cardinal:audio_out_1 "${ports[0]}" 2>/dev/null || true
		pw-link Cardinal:audio_out_2 "${ports[1]:-${ports[0]}}" 2>/dev/null || true
		echo "Audio: Cardinal → $sink"
	fi
fi
wait $pid
