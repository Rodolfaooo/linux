#!/bin/bash

BASE_DIR="$HOME/filemanager"
LOG_FILE="./logs/system.log"
REPORT_DIR="./reports"
MAX_FILE_SIZE=10485760  # 10MB
ALLOWED_EXTS="txt|sh|log|conf|csv|md"

init_dirs() {
    mkdir -p "$BASE_DIR" "$REPORT_DIR" "$(dirname "$LOG_FILE")"
    touch "$LOG_FILE"
}

get_timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}
