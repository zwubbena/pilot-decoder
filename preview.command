#!/bin/bash
# ============================================================
# PilotDECODER — local preview server (macOS)
# Double-click this file to browse the whole site exactly as it
# will appear on pilotdecoder.com, including links between pages.
# Close this Terminal window (or press Ctrl+C) to stop it.
# ============================================================
cd "$(dirname "$0")"
echo "PilotDECODER preview running at http://localhost:8000/"
echo "Close this window (or press Ctrl+C) to stop."
( sleep 1; open "http://localhost:8000/" ) &
python3 -m http.server 8000 2>/dev/null || {
  echo "A preview server is already running — opening the browser."
  open "http://localhost:8000/"
  sleep 2
}
