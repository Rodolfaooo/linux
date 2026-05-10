#!/bin/bash

source config.sh

validate_filename() {
    [[ -n "$1" && ! "$1" =~ [/\\] ]]
}

validate_permission() {
    [[ "$1" =~ ^[0-7]{3}$ ]]
}

file_exists() {
    [[ -f "$BASE_DIR/$1" ]]
}

show_success() {
    echo -e "\033[0;32m✓ $1\033[0m"
}

show_error() {
    echo -e "\033[0;31m✗ $1\033[0m"
}

show_info() {
    echo -e "\033[0;36mℹ $1\033[0m"
}

show_warning() {
    echo -e "\033[1;33m⚠ $1\033[0m"
}
