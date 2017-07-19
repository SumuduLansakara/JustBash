# source dependent scripts
. $ROOT/terminal/settings.sh
. $ROOT/terminal/configs.sh

# private functions
function __init__(){
    if $TERMINAL_INITIALIZED; then
        return
    fi
    export TERMINAL_INITIALIZED=true

    if ! $ENABLE_COLORS; then
        export DBG_CLR=
        export TXT_CLR=
        export INF_CLR=
        export WRN_CLR=
        export ERR_CLR=
        export RST_CLR=
    fi
    if ! $DISPLAY_TAGS; then
        export DBG_TAG=
        export TXT_TAG=
        export INF_TAG=
        export WRN_TAG=
        export ERR_TAG=
    fi
    if $ENABLE_LOGGING; then
        disable_logging
        print_dbg "logging enabled"
        enable_logging
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
    echo -n "$1"
    if $END_WITH_NEWLINE; then
        echo ""
    fi
}

# public functions
function print_dbg() {
    __print_clr__ "$DBG_CLR"
    __print_tag__ "$DBG_TAG"
    __print__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_dbg "[term] $1"
    fi
}

function print_txt() {
    __print_clr__ "$TXT_CLR"
    __print_tag__ "$TXT_TAG"
    __print__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_txt "[term] $1"
    fi
}

function print_inf() {
    __print_clr__ "$INF_CLR"
    __print_tag__ "$INF_TAG"
    __print__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_inf "[term] $1"
    fi
}

function print_wrn() {
    __print_clr__ "$WRN_CLR"
    __print_tag__ "$WRN_TAG"
    __print__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_wrn "[term] $1"
    fi
}

function print_err() {
    __print_clr__ "$ERR_CLR"
    __print_tag__ "$ERR_TAG"
    __print__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_err "[term] $1"
    fi
}

function print_tool_output(){
    __print__ "$1"
    if $ENABLE_LOGGING; then
        __log__ "[stdout][bgn]"
        disable_log_timestamp
        __log__ "$1"
        enable_log_timestamp
        __log__ "[stdout][end]"
    fi
}

function enable_autonewline() {
    END_WITH_NEWLINE=true
}

function disable_autonewline() {
    END_WITH_NEWLINE=false
}

function enable_logging(){
    ENABLE_LOGGING=true
}

function disable_logging(){
    ENABLE_LOGGING=false
}


# entry point
__init__
export -f __print_clr__
export -f __print_tag__
export -f __print__

export -f enable_autonewline
export -f disable_autonewline
export -f enable_logging
export -f disable_logging

export -f print_dbg
export -f print_txt
export -f print_inf
export -f print_wrn
export -f print_err
export -f print_tool_output

if [[ $1 == "DEBUG" ]]; then
    print_txt "text message"
    print_inf "info message"
    print_wrn "warn message"
    print_err "erro message"
fi
