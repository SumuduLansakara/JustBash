#!/usr/bin/env bash
function __init__(){
    export ROOT="$(dirname $0)"
    source $ROOT/settings.sh

    if [[ $# -eq 0 ]]; then
        echo "[DBG] running in debug mode"
        export INSTANCEID="$(date +%Y%M%d%H%m%S%3N)"
    else
        export INSTANCEID="$1"
    fi

    source $ROOT/terminal/main.sh
}

__init__ $*

print_txt "txt message"
print_inf "inf message"
print_wrn "wrn message"
print_err "err message"

disable_logging
print_txt "silent message"
enable_logging
print_txt "logged message"
