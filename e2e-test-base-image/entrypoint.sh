#!/usr/bin/env bash
set -eu -o pipefail

cleanup() {
  if [ -n "${XVFB_PID:-}" ]; then
    kill "$XVFB_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

Xvfb "$DISPLAY" -screen 0 1280x800x16 -nolisten tcp 2> >(grep -v 'xkbcomp\|Could not resolve keysym\|not fatal' >&2) &
XVFB_PID=$!

# Wait for Xvfb to become ready
for i in $(seq 1 10); do
  if xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
    break
  fi
  if ! kill -0 "$XVFB_PID" 2>/dev/null; then
    echo "ERROR: Xvfb process died unexpectedly" >&2
    exit 1
  fi
  sleep 0.5
done

if ! xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
  echo "ERROR: Xvfb failed to start within 5 seconds" >&2
  exit 1
fi

exec "$@"
