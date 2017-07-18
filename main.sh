#!/usr/bin/env bash
function __init__(){
    export ROOT="$PWD"
    export INSTANCEID="$(date +%Y%M%d%H%m%S%3N)"
    source terminal/main.sh
}

__init__

print_txt "txt message"
print_inf "inf message"
print_wrn "wrn message"
print_err "err message"

disable_logging
print_txt "silent message"
enable_logging
print_txt "logged message"
