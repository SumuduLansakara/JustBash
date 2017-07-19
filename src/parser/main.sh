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
    # $1: min arg count
    # $2: max arg count
    # $3: recieved arg count
    if [[ $1 != '-' ]]; then
        if [[ $3 < $1 ]]; then
            return 1
        fi
    fi
    if [[ $2 != '-' ]]; then
        if [[ $3 > $2 ]]; then
            return 2
        fi
    fi
}


# entry point
__init__

export -f validate_arg_count

if [[ $1 == "DEBUG" ]]; then
    validate_arg_count 2 3 5
    exit 0
fi
