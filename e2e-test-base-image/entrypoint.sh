#!/usr/bin/env bash

Xvfb $DISPLAY -screen 0 1280x800x16 -nolisten tcp &

exec "$@"