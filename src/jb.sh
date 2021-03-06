#!/usr/bin/env bash
export ROOT="$(dirname $0)"
. $ROOT/settings.sh

function __init__(){
    __argparse__ $*

    if $DEBUG_MODE; then
        export INSTANCEID="DEBUG"
        echo "[DBG] starting debug instance: $INSTANCEID"
    fi

    # load logger
    if $ENABLE_LOGGER; then
        . $ROOT/logger/main.sh
        if [[ $? -ne 0 ]]; then
            echo "[WRN] errors occurred while loading logger"
        fi
        log_inf "[***] JustBash logger started [PID=$$]"
    fi
    # load terminal
    . $ROOT/terminal/main.sh
    if ! $ENABLE_LOGGER; then
        print_wrn "************************************************************"
        print_wrn "*** LOGGING DISABLED! THIS INSTANCE WILL NOT BE LOGGED!! ***"
        print_wrn "************************************************************"
    fi

    # load artist
    if $ENABLE_ARTIST; then
        . $ROOT/artist/main.sh
        if [[ $? -ne 0 ]]; then
            print_wrn "errors occurred while loading artist"
        fi
        print_dbg "artist loaded"
        if $ENABLE_WELCOME_BANNER; then
            draw_inf "Welcome to"
            draw_inf " JustBash!"
            draw_inf "----------"
        fi
    fi

    # load argument parser
    . $ROOT/parser/main.sh

    # load print utilities
    if $ENABLE_PRINTUTILS; then
        . $ROOT/print_utils/main.sh
    fi

    # check tool directory available
    if ! [[ -d $SCRIPTDIR ]]; then
        print_err "tools directory '$SCRIPTDIR' not available"
        exit 1
    fi
}

function __argparse__(){
    getopt --test >/dev/null
    if [[ $? -ne 4 ]]; then
        echo "[ERR][MAIN] unable to parse arguments"
        exit 1
    fi

    # id, command, log-tag, debug, help
    SHORT_ARGS=i:c:l:dh

    PARSED=$(getopt --options $SHORT_ARGS --name "$0" -- "$@")
    if [[ $? -ne 0 ]]; then
        echo "[ERR][MAIN] invalid arguments"
        exit 1
    fi

    eval set -- "$PARSED"

    export DEBUG_MODE=false
    export INSTANCEID=0
    while true; do
        case "$1" in
            -i)
                export INSTANCEID="$2"
                shift 2
                ;;
            -c)
                CMD=$2
                shift 2
                ;;
            -l)
                export LOGTAG="$2 "
                shift 2
                ;;
            -d)
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
    echo "  $0 [-i instance_id] [-l log_tag] [-c command_name] [-d] [-h] "
    echo ""
    echo "Options:"
    echo "  -i <instance_id>  : JustBash instance id"
    echo "  -l <log_tag>      : optional tag to be used when logging current instance"
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
    CMD_PATH="$SCRIPTDIR/$CMD.sh"
    if ! [[ -e "$CMD_PATH" ]]; then
        print_err "'$CMD.sh' script not found in '$SCRIPTDIR'"
        exit 1
    fi
    if ! [[ -f $CMD_PATH ]]; then
        print_err "invalid file found for '$CMD' at '$CMD_PATH'"
        exit 1
    fi
}

function execute_comand(){
    print_dbg "command '$CMD' is about to be invoked with arguments '$CMD_ARGS'"
    validate_arg_count "$SCRIPTDIR/$CMD.sh" "$CMD_ARG_COUNT"

    if $ENABLE_INTERACTIVE_MODE; then
        print_dbg "invoking command in the same shell"
        bash $SCRIPTDIR/$CMD.sh $CMD_ARGS
        CMD_ERR="$?"
        print_dbg "command '$CMD' returned with error code '$CMD_ERR'"
    else
        print_dbg "invoking command in a sub-shell"
        output=$(bash $SCRIPTDIR/$CMD.sh $CMD_ARGS 2>&1)
        CMD_ERR="$?"
        print_dbg "command '$CMD' returned with error code '$CMD_ERR'"
        print_tool_output "$output"
    fi
    if [[ $CMD_ERR -ne 0 ]]; then
        print_err "$CMD returned with error $CMD_ERR"
    fi
}

# execute
__init__ $*

validate_command
execute_comand

log_inf "[***] JustBash instance exiting"
