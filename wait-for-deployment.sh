#!/bin/bash
set -euo pipefail

deadline=$((SECONDS + TIMEOUT))

while :; do
  active=$(curl -fsS --max-time 10 "$URL" | jq -r --arg f "$FIELD" 'getpath($f | split(".")) // empty' || true)
  echo "$FIELD: ${active:-(no response)}"
  [ "$active" = "$EXPECTED" ] && exit 0
  if [ "$SECONDS" -ge "$deadline" ]; then
    echo "::error::$URL serves ${active:-nothing} instead of $EXPECTED after $TIMEOUT s"
    exit 1
  fi
  sleep "$INTERVAL"
done
