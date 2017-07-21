# source dependent scripts
. $ROOT/artist/settings.sh
. $ROOT/artist/configs.sh

# private functions
function __init__(){
    if [[ -z $TERMINAL_INITIALIZED ]] || [[ "$TERMINAL_INITIALIZED" == "false" ]]; then
        echo "[err][rewriter] JustBash terminal must be initialized before the artist"
        exit 1
    fi
    if $REWRITER_INITIALIZED; then
        return
    fi
    export REWRITER_INITIALIZED=true
}

function __rewrite__(){
    # $1: line to be re-written
    # Rewrite the previous line
    echo -ne "\033[1A\033[2K"
    echo "$1"
}

# public functions
function rewrite_txt() {
    __print_clr__ "$TXT_CLR"
    __rewrite__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_TERM_LOGGING; then
        log_txt "[rwt] $1"
    fi
}

function rewrite_inf() {
    __print_clr__ "$INF_CLR"
    __rewrite__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_TERM_LOGGING; then
        log_inf "[rwt] $1"
    fi
}

function rewrite_wrn() {
    __print_clr__ "$WRN_CLR"
    __rewrite__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_TERM_LOGGING; then
        log_wrn "[rwt] $1"
    fi
}

function rewrite_err() {
    __print_clr__ "$ERR_CLR"
    __rewrite__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_TERM_LOGGING; then
        log_err "[rwt] $1"
    fi
}

function clear_screen(){
    echo -ne '\033[2J\033[0;0f'
}

function hide_cursor(){
    echo -ne "\033[?25l"
}

function show_cursor(){
    echo -ne "\033[?25h"
}

# entry point
__init__

export -f __rewrite__

export -f rewrite_txt
export -f rewrite_inf
export -f rewrite_wrn
export -f rewrite_err

export -f clear_screen
export -f hide_cursor
export -f show_cursor
