#!/usr/bin/env bash
function __init__(){
    export ROOT="$(dirname $0)"
    source $ROOT/settings.sh

    __argparse__ $*

    if [[ -z $INSTANCEID ]]; then
        if ! $DEBUG_MODE; then
            echo "[ERR][MAIN] instance ID not provided"
            exit 1
        fi
        export INSTANCEID="$(date +%Y%M%d%H%m%S%3N)"
        echo "[DBG] starting debug instance: $INSTANCEID"
    fi

    source $ROOT/terminal/main.sh
}

function __argparse__(){
    getopt --test >/dev/null
    if [[ $? -ne 4 ]]; then
        echo "[ERR][MAIN] unable to parse arguments"
        exit 1
    fi

    # id, cmd, debug
    SHORT_ARGS=i:c:d

    PARSED=$(getopt --options $SHORT_ARGS --name "$0" -- "$@")
    if [[ $? -ne 0 ]]; then
        echo "[ERR][MAIN] invalid arguments"
        exit 1
    fi

    eval set -- "$PARSED"

    export DEBUG_MODE=false
    while true; do
        case "$1" in
            -i|--id)
                export INSTANCEID="$2"
                shift 2
                ;;
            -c|--cmd)
                COMMAND=$2
                shift 2
                ;;
            -d|--debug)
                export DEBUG_MODE=true
                shift
                ;;
            --)
                shift
                break
                ;;
            *)
                echo "[WRN][MAIN] invalid argument $1"
                shift
                ;;
        esac
    done

    CMD_ARGS=$*
}

__init__ $*

bash $ROOT/tools/$COMMAND.sh $CMD_ARGS

print_txt "txt message"
print_inf "inf message"
print_wrn "wrn message"
print_err "err message"

disable_logging
print_txt "silent message"
enable_logging
print_txt "logged message"
