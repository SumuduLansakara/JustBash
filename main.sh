#!/usr/bin/env bash
export ROOT="$PWD"

source terminal/main.sh

print_txt "txt message"
print_inf "inf message"
print_wrn "wrn message"
print_err "err message"

disable_logging
print_txt "silent message"
enable_logging
print_txt "logged message"
