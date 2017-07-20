# source dependent scripts
. $ROOT/artist/settings.sh
. $ROOT/artist/configs.sh

# private functions
function __init__(){
    if $ARTIST_INITIALIZED; then
        return
    fi
    export ARTIST_INITIALIZED=true

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

function __load_symbols__(){
    # $1: filename
    for line in $(sed -n '/#>METADATA_BEGIN/,/#>METADATA_END/p' "$SYMBOL_FILE"); do
        if [[ $line =~ ^#\>BLOCK_WIDTH=([0-9]*)$ ]]; then
            export block_width="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^#\>SYMBOL_HEIGHT=([0-9]*)$ ]]; then
            export symbol_height="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^#\>START_ASCII=([0-9]*)$ ]]; then
            export start_ascii="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^#\>SYMBOL_COUNT=([0-9]*)$ ]]; then
            export symbol_count="${BASH_REMATCH[1]}"
        fi
    done
    if [[ -z $block_width ]] || [[ -z $symbol_height ]]|| [[ -z $start_ascii ]]|| [[ -z $symbol_count ]]; then
        echo "insufficient symbol file metadata"
    fi
    symbol_start_line=$(($(sed -n '/#>METADATA_END/=' "$SYMBOL_FILE") + 1))
    symbol_end_line=$(($(($symbol_count * $(($symbol_height+1))))+1))

    for sym_beg in $(seq $symbol_start_line $(($symbol_height+1)) $symbol_end_line); do
        ALPHABET[$start_ascii]=$(sed -n "$(($sym_beg+1)),$(($sym_beg+$symbol_height))p" "$SYMBOL_FILE")
        ALPHABET_WIDTH[$start_ascii]=$(sed -n "${sym_beg}s/.*WIDTH=\([0-9]*\).*/\1/p" "$SYMBOL_FILE")
        ALPHABET_BLOCK_WIDTH[$start_ascii]=$(($block_width+1))
        start_ascii=$(($start_ascii+1))
    done
}

function __draw_ascii__(){
    if ! [[ -v ALPHABET[@] ]]; then
        __load_symbols__ "$SYMBOL_FILE"
    fi
    for row in $(seq 0 $(($symbol_height-1))); do
        for sym_ascii in $*; do
            for col in $(seq 0 $((${ALPHABET_WIDTH[$sym_ascii]}-1))); do
                index=$(($(($row * ${ALPHABET_BLOCK_WIDTH[$sym_ascii]}))+$col))
                symbol=${ALPHABET[$sym_ascii]}
                char="${symbol:$index:1}"
                echo -n "${char/\./ }"
            done
        done
        echo ""
    done
}

# public functions
function __draw_text__(){
    for (( i=0; i<${#1}; i++)); do
        l[$i]=$(printf '%d\n' "'${1:i:1}")
    done
    __draw_ascii__ ${l[@]:0:${#1}}
}

function __print_clr__(){
    echo -ne "\033[$1m"
}

# public functions
function draw_txt() {
    __print_clr__ "$TXT_CLR"
    __draw_text__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_txt "[term] $1"
    fi
}

function draw_inf() {
    __print_clr__ "$INF_CLR"
    __draw_text__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_inf "[term] $1"
    fi
}

function draw_wrn() {
    __print_clr__ "$WRN_CLR"
    __draw_text__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_wrn "[term] $1"
    fi
}

function draw_err() {
    __print_clr__ "$ERR_CLR"
    __draw_text__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_err "[term] $1"
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
export -f __draw_text__
export -f __draw_ascii__
export -f __load_symbols__

export -f enable_autonewline
export -f disable_autonewline
export -f enable_logging
export -f disable_logging

export -f draw_txt
export -f draw_inf
export -f draw_wrn
export -f draw_err

if [[ $1 == "DEBUG" ]]; then
    print_txt "text message"
    print_inf "info message"
    print_wrn "warn message"
    print_err "erro message"
fi
