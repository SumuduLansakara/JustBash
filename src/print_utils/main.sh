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
    for (( j=1; j<=$3; j++ )); do
        if [[ $(($1 * $3 / $2)) -lt $j ]]; then
            __print__ '-'
        else
            __print__ '#'
        fi
    done
    __print__ "] $(printf '%2s' $(($1 * 100 / $2)) %)"
    enable_autonewline
}

function print_spinner(){
    # $1: message
    # $2: optional spin interval
    # Animate a spinner until the last backgrounded process ends

    if [[ -z $2 ]]; then
        SPIN_INTERVAL=0.5
    else
        SPIN_INTERVAL=$2
    fi
    disable_autonewline
    disable_cursor
    __print__ "$1 "
	_j=1
	_chars='/-\|'
	while true
	do
		printf "\b${_chars:_j++%${#_chars}:1}"
        kill -0 $! &>/dev/null
        if [[ $? -ne 0 ]]; then
            printf "\b \n"
            break
        fi
        sleep $SPIN_INTERVAL
	done
    enable_autonewline
    enable_cursor
}

# entry point
__init__

export -f print_progress
export -f print_spinner
