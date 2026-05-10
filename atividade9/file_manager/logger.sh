#!/bin/bash

source config.sh

log() {
    local level="$1"
    local msg="$2"
    echo "$(get_timestamp) [$level] $msg" >> "$LOG_FILE"
}

log_info() { log "INFO" "$1"; }
log_error() { log "ERROR" "$1"; show_error "$1"; }
log_warning() { log "WARNING" "$1"; }

view_logs() {
    if [[ -f "$LOG_FILE" ]]; then
        tail -n "${1:-30}" "$LOG_FILE"
    else
        show_error "Log não encontrado"
    fi
}

clear_logs() {
    > "$LOG_FILE"
    log_info "Logs limpos"
    show_success "Logs limpos"
}
