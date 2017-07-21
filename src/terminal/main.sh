# source dependent scripts
. $ROOT/terminal/settings.sh
. $ROOT/terminal/configs.sh

# private functions
function __init__(){
    if $TERMINAL_INITIALIZED; then
        return
    fi
    export TERMINAL_INITIALIZED=true

    if ! $ENABLE_LOGGER; then
        export ENABLE_TERM_LOGGING=false
    fi
}

function __print_tag__(){
    if $ENABLE_TAGS; then
        echo -n "$1"
    fi
}

function __print__(){
    echo -n "$1"
    if $END_WITH_NEWLINE; then
        echo ""
    fi
}

# public functions
function print_dbg() {
    if $DEBUG_MODE; then
        set_color "$DBG_CLR"
        __print_tag__ "$DBG_TAG"
        __print__ "$1"
        set_color "$RST_CLR"
    fi
    if $ENABLE_TERM_LOGGING; then
        log_dbg "[term] $1"
    fi
}

function print_txt() {
    if $ENABLE_REWRITE; then
        clear_prev_line
    fi
    set_color "$TXT_CLR"
    __print_tag__ "$TXT_TAG"
    __print__ "$1"
    set_color "$RST_CLR"
    if $ENABLE_TERM_LOGGING; then
        log_txt "[term] $1"
    fi
}

function print_inf() {
    if $ENABLE_REWRITE; then
        clear_prev_line
    fi
    set_color "$INF_CLR"
    __print_tag__ "$INF_TAG"
    __print__ "$1"
    set_color "$RST_CLR"
    if $ENABLE_TERM_LOGGING; then
        log_inf "[term] $1"
    fi
}

function print_wrn() {
    if $ENABLE_REWRITE; then
        clear_prev_line
    fi
    set_color "$WRN_CLR"
    __print_tag__ "$WRN_TAG"
    __print__ "$1"
    set_color "$RST_CLR"
    if $ENABLE_TERM_LOGGING; then
        log_wrn "[term] $1"
    fi
}

function print_err() {
    if $ENABLE_REWRITE; then
        clear_prev_line
    fi
    set_color "$ERR_CLR"
    __print_tag__ "$ERR_TAG"
    __print__ "$1"
    set_color "$RST_CLR"
    if $ENABLE_TERM_LOGGING; then
        log_err "[term] $1"
    fi
}

function print_tool_output(){
    print_dbg "start printing and logging command output"
    disable_autonewline
    __print__ "$1"
    enable_autonewline
    if $ENABLE_TERM_LOGGING; then
        __log__ "[stdout][bgn]"
        disable_log_timestamp
        __log__ "$1"
        enable_log_timestamp
        __log__ "[stdout][end]"
    fi
    print_dbg "end printing and logging command output"
}

function set_color(){
    if [[ $1 -gt 30 ]] && [[ $1 -lt 40 ]] || [[ $1 -eq 0 ]]; then
        if $ENABLE_COLORS; then
            echo -ne "\033[$1m"
        fi
        return
    fi
    print_wrn "invalid color code '$1'"
}


function enable_autonewline() {
    export END_WITH_NEWLINE=true
}

function disable_autonewline() {
    export END_WITH_NEWLINE=false
}

function enable_term_logging(){
    export ENABLE_TERM_LOGGING=true
}

function disable_term_logging(){
    export ENABLE_TERM_LOGGING=false
}

function enable_rewrite(){
    export ENABLE_REWRITE=true
}

function disable_rewrite(){
    export ENABLE_REWRITE=false
}

function clear_screen(){
    echo -ne '\033[2J\033[0;0f'
}

function clear_prev_line(){
    echo -ne '\033[1A\033[2K'
}

function enable_cursor(){
    echo -ne "\033[?25h"
}

function disable_cursor(){
    echo -ne "\033[?25l"
}

function enable_colors(){
    export ENABLE_COLORS=true
}

function disable_colors(){
    export ENABLE_COLORS=false
}

function enable_print_tags(){
    export ENABLE_TAGS=true
}

function disable_print_tags(){
    export ENABLE_TAGS=false
}

# entry point
__init__
export -f __print_tag__
export -f __print__

export -f set_color
export -f enable_autonewline
export -f disable_autonewline
export -f enable_term_logging
export -f disable_term_logging
export -f enable_rewrite
export -f disable_rewrite
export -f enable_colors
export -f disable_colors
export -f enable_print_tags
export -f disable_print_tags


export -f clear_prev_line
export -f clear_screen
export -f enable_cursor
export -f disable_cursor

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
