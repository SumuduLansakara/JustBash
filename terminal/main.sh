# source dependent scripts
. $ROOT/terminal/settings.sh
. $ROOT/terminal/configs.sh

# private functions
function __init__(){
    if ! [[ -z $TERMINAL_INITIALIZED ]]; then
        return
    fi
    TERMINAL_INITIALIZED=true

    if ! $ENABLE_COLORS; then
        ERR_CLR=
        INF_CLR=
        WRN_CLR=
        TXT_CLR=
        RST_CLR=
    fi
    if ! $DISPLAY_TAGS; then
        ERR_TAG=
        INF_TAG=
        WRN_TAG=
        TXT_TAG=
    fi
    if $ENABLE_LOGGING; then
        echo "LOGGING ENABLE!"
        . $ROOT/logger/main.sh
        if [[ $? -ne 0 ]]; then
            print_err "errors occured while sourcing logger"
        fi
    fi
}

function __print_clr__(){
    echo -ne "\033[$1m"
}

function __print_tag__(){
    echo -n "$1"
}

function __print__(){
    if [[ $2 != "-" ]]; then
        echo -n ""
    fi
    echo -n "$1"
    if $END_WITH_NEWLINE; then
        echo ""
    fi
}

# public functions
function set_newline() {
    END_WITH_NEWLINE=true
}

function unset_newline() {
    END_WITH_NEWLINE=false
}

function enable_logging(){
    ENABLE_LOGGING=true
}

function disable_logging(){
    ENABLE_LOGGING=false
}

function print_txt() {
    __print_clr__ "$TXT_CLR"
    __print_tag__ "$TXT_TAG"
    __print__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_txt "$1"
    fi
}

function print_inf() {
    __print_clr__ "$INF_CLR"
    __print_tag__ "$INF_TAG"
    __print__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_inf "$1"
    fi
}

function print_wrn() {
    __print_clr__ "$WRN_CLR"
    __print_tag__ "$WRN_TAG"
    __print__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_wrn "$1"
    fi
}

function print_err() {
    __print_clr__ "$ERR_CLR"
    __print_tag__ "$ERR_TAG"
    __print__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_err "$1"
    fi
}

# entry point
__init__
export -f set_newline
export -f unset_newline
export -f enable_logging
export -f disable_logging
export -f print_txt
export -f print_inf
export -f print_wrn
export -f print_err

if [[ $1 == "DEBUG" ]]; then
    print_txt "text message"
    print_inf "info message"
    print_wrn "warn message"
    print_err "erro message"
fi
