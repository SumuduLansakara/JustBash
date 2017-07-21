#!/usr/bin/env bash
export ROOT="$(dirname $0)"
source $ROOT/settings.sh

function __init__(){
    __argparse__ $*

    if [[ -z $INSTANCEID ]]; then
        if ! $DEBUG_MODE; then
            echo "[ERR] instance ID not provided"
            exit 1
        fi
        export INSTANCEID="DEBUG"
        echo "[DBG] starting debug instance: $INSTANCEID"
    fi

    # load logger
    if $ENABLE_LOGGER; then
        . $ROOT/logger/main.sh
        if [[ $? -ne 0 ]]; then
            echo "[WRN] errors occured while loading logger"
        fi
        log_inf "JustBash logger started"
    fi
    # load terminal
    source $ROOT/terminal/main.sh
    # load artist
    if $ENABLE_ARTIST; then
        . $ROOT/artist/main.sh
        if [[ $? -ne 0 ]]; then
            echo "[WRN] errors occured while loading logger"
        fi
        print_dbg "artist loaded"
        if $ENABLE_WELCOME_BANNER; then
            draw_inf "Welcome to"
            draw_inf " JustBash!"
            draw_inf "----------"
        fi
    fi
    # load arg parser
    source $ROOT/parser/main.sh

    if ! $ENABLE_LOGGER; then
        print_wrn "************************************************************"
        print_wrn "*** LOGGING DISABLED! THIS INSTANCE WILL NOT BE LOGGED!! ***"
        print_wrn "************************************************************"
    fi

    # check tool directory available
    if ! [[ -d $TOOLDIR ]]; then
        print_err "tools directory '$TOOLDIR' not available"
        exit 1
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

function validate_command(){
    # parse and validate command
    if [[ -z "$CMD" ]]; then
        print_err "no command provided"
        exit 1
    fi
    CMD_PATH="$TOOLDIR/$CMD.sh"
    if ! [[ -e "$CMD_PATH" ]]; then
        print_err "'$CMD.sh' script not found"
        exit 1
    fi
    if ! [[ -f $CMD_PATH ]]; then
        print_err "invalid file found for '$CMD' at '$CMD_PATH'"
        exit 1
    fi
}

function execute_comand(){
    print_dbg "command '$CMD' is about to be invoked with args '$CMD_ARGS'"
    validate_arg_count "$TOOLDIR/$CMD.sh" "$CMD_ARG_COUNT"

    print_dbg "invking command '$CMD'"
    output=$(bash $TOOLDIR/$CMD.sh $CMD_ARGS 2>&1)
    CMD_ERR="$?"
    print_dbg "command '$CMD' returned with error code '$CMD_ERR'"
    print_tool_output "$output"
    if [[ $CMD_ERR -ne 0 ]]; then
        print_err "$CMD returned with error $CMD_ERR"
    fi
}

# execute
__init__ $*

validate_command
execute_comand
