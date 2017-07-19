# source dependent scripts
. $ROOT/parser/settings.sh
. $ROOT/parser/configs.sh

# private functions
function __init__()
{
    if ! [[ -z $PARSER_INITIALIZED ]]; then
        return
    fi
    export PARSER_INITIALIZED=true
}

function validate_arg_count(){
    # $1: min arg count
    # $2: max arg count
    # $3: recieved arg count
    if [[ $3 < $1 ]]; then
        print_err "not enough input arguments provided. minimum expected $1, provided $3"
        exit 1
    fi
    if [[ $3 > $2 ]]; then
        print_err "exceeding number of input arguments provided. maximum expected $2, provided $3"
        exit 1
    fi
}


# entry point
__init__

export -f validate_arg_count

if [[ $1 == "DEBUG" ]]; then
    validate_arg_count 2 3 5
    exit 0
fi
