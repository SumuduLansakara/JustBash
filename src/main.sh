#!/usr/bin/env bash
export ROOT="$(dirname $0)"
source $ROOT/settings.sh

function __init__(){
    __argparse__ $*

    if [[ -z $INSTANCEID ]]; then
        if ! $DEBUG_MODE; then
            echo "[ERR][MAIN] instance ID not provided"
            exit 1
        fi
        export INSTANCEID="DEBUG"
        echo "[DBG] starting debug instance: $INSTANCEID"
    fi

    source $ROOT/terminal/main.sh
    source $ROOT/parser/main.sh
    if $LOAD_ARTIST; then
        source $ROOT/artist/main.sh
        print_dbg "artist loaded"
        if $ENABLE_WELCOME_BANNER; then
            draw_inf "Welcome to"
            draw_inf " JustBash!"
            draw_inf "----------"
        fi
    fi
}

function __argparse__(){
    getopt --test >/dev/null
    if [[ $? -ne 4 ]]; then
        echo "[ERR][MAIN] unable to parse arguments"
        exit 1
    fi

    # id, cmd, debug
    SHORT_ARGS=i:c:dh

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
            -h)
                __help__
                exit 0
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
    CMD_ARG_COUNT="${#*}"
}

function __help__(){
    echo "Usage:"
    echo "  $0 [-i instance_id] [-c command_name] [-d] [-h] "
    echo ""
    echo "Options:"
    echo "  -i <instance_id>  : MrBash instance id"
    echo "  -c <command_name> : command to be invoked"
    echo "  -d                : enable debug output"
    echo "  -h                : display this help message"
}

# execute
__init__ $*

# parse and validate command
if [[ -z $CMD ]]; then
    print_err "no command provided"
    exit 1
fi
CMD_PATH=$ROOT/tools/$CMD.sh
if ! [[ -e $CMD_PATH ]]; then
    print_err "$CMD command not found"
    exit 1
fi
if ! [[ -f $CMD_PATH ]]; then
    print_err "invalid file found for $CMD at $CMD_PATH"
    exit 1
fi

print_dbg "command '$CMD' is about to be invoked with args '$CMD_ARGS'"
print_dbg "validating argument count"
headline=$(head -n 1 $ROOT/tools/$CMD.sh)
if [[ "$headline" =~ ^\#arg_count=([0-9]*):([0-9]*)$ ]]; then
    min="${BASH_REMATCH[1]}"
    max="${BASH_REMATCH[2]}"
    if [[ -z $min ]]; then
        min='-'
    fi
    if [[ -z $max ]]; then
        max='-'
    fi
    validate_arg_count $min $max $CMD_ARG_COUNT
    RETURN_CODE="$?"
    if [[ "$RETURN_CODE" == 1 ]]; then
        print_err "insufficient number of  input arguments provided for '$CMD' command. minimum expected $min, provided $CMD_ARG_COUNT"
        exit -1
    elif [[ "$RETURN_CODE" == 2 ]]; then
        print_err "exceeding number of input arguments provided for '$CMD' command. maximum expected $max, provided $CMD_ARG_COUNT"
        exit -1
    fi
    print_dbg "argument count valid. '$CMD_ARG_COUNT' provided, expected [$min:$max]"
else
    print_dbg "argument counts are not defined for '$CMD' command"
fi

# invoke command
print_dbg "invking command '$CMD'"
output=$(bash $ROOT/tools/$CMD.sh $CMD_ARGS 2>&1)
CMD_ERR="$?"
print_dbg "command '$CMD' returned with error code '$CMD_ERR'"
print_dbg "start printing and logging command output"
disable_autonewline
print_tool_output "$output"
enable_autonewline
print_dbg "end printing and logging command output"
if [[ $CMD_ERR -ne 0 ]]; then
    print_err "$CMD returned with error $CMD_ERR"
fi
