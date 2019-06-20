# source dependent scripts
. $ROOT/parser/settings.sh
. $ROOT/parser/configs.sh

# private functions
function __init__()
{
    if $PARSER_INITIALIZED; then
        return
    fi
    export PARSER_INITIALIZED=true
}

function validate_arg_count(){
    # $1: script path
    # $2: received arg count
    # return 0 => valid argument count received
    # return 1 => metadata required for argument validation not available

    print_dbg "start argument count validation"
    headline=$(head -n 1 "$1")
    if [[ "$headline" =~ ^\#ARG_COUNT=([0-9]*):([0-9]*)$ ]]; then
        min="${BASH_REMATCH[1]}"
        max="${BASH_REMATCH[2]}"
        if [[ -z $min ]]; then
            min='0'
        fi
        if [[ -z $max ]]; then
            max='99'
        fi
        if [[ $min -gt $max ]]; then
            print_err "expected argument count range is invalid. expected min ($min) > expected max ($max)"
            exit 1
        fi
        if [[ $2 -lt $min ]]; then
            print_err "insufficient number of arguments provided. received ($2) < expected min ($min)" 
            exit 1
        fi
        if [[ $2 -gt $max ]]; then
            print_err "exceeding number of arguments provided. received ($2) > expected max ($max)"
            exit 1
        fi
        print_dbg "argument count valid. '$2' provided, expected [$min:$max]"
        return 0
    fi
    print_dbg "metadata required for argument count validation not available"
    return 1
}

# entry point
__init__

export -f validate_arg_count

if [[ $1 == "DEBUG" ]]; then
    validate_arg_count 2 3 5
    exit 0
fi
