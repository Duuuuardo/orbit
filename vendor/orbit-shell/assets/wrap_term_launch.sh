#!/usr/bin/env sh

cat ~/.local/state/orbit/sequences.txt 2>/dev/null

exec "$@"
