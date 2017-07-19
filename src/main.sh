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
        export INSTANCEID="$(date +%Y%M%d%H%m%S%3N)-DEBUG"
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
                CMD=$2
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

# start execution
CMD_PATH=$ROOT/tools/$CMD.sh
if ! [[ -e $CMD_PATH ]]; then
    print_err "$CMD command not found"
    exit 1
fi
if ! [[ -f $CMD_PATH ]]; then
    print_err "invalid file found for $CMD at $CMD_PATH"
    exit 1
fi
print_dbg "starting command '$CMD' with args '$CMD_ARGS'"
bash $ROOT/tools/$CMD.sh $CMD_ARGS
CMD_ERR="$?"
print_dbg "command '$CMD' returned with error code '$CMD_ERR'"
if [[ $CMD_ERR -ne 0 ]]; then
    print_err "$CMD returned with error $CMD_ERR"
fi
