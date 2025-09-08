#!/bin/bash
AUDIT_DIR="/database/config/db2inst1"
OUT_FILE="$AUDIT_DIR/audit.out"

# Find the latest archived log file
LATEST_LOG=$(ls -1 $AUDIT_DIR/db2audit.db.SAMPLE.log.0.* | sort | tail -n 1)

if [[ -z "$LATEST_LOG" ]]; then
    echo "No archived log found."
    exit 1
fi

# Extract into audit.out
db2audit extract file "$OUT_FILE" from files "$LATEST_LOG"

# Ensure Splunk can read it
chmod 644 "$OUT_FILE"

echo "Extracted latest audit log: $LATEST_LOG -> $OUT_FILE"