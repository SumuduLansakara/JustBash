. $ROOT/print_utils/configs.sh

function __init__(){
    if [[ -z $TERMINAL_INITIALIZED ]] || [[ "$TERMINAL_INITIALIZED" == "false" ]]; then
        echo "[err][print_utils] JustBash terminal must be initialized first"
        exit 1
    fi
    if $PRINT_UTILS_INITIALIZED; then
        return
    fi
    export PRINT_UTILS_INITIALIZED=true
}

function print_progress(){
    # $1: current progress value
    # $2: max progress value
    # $3: progress width

    disable_autonewline
    __print__ '['
    for j in $(seq 1 $3); do
        if [[ $(($1 * $3 / $2)) -lt $j ]]; then
            __print__ '-'
        else
            __print__ '#'
        fi
    done
    __print__ "] $(printf '%2s' $(($1 * 100 / $2)) %)"
    enable_term_logging
}

# entry point
__init__

export -f print_progress
