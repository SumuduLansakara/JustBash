# source dependent scripts
. $ROOT/artist/settings.sh
. $ROOT/artist/configs.sh

# private functions
function __init__(){
    if [[ -z $TERMINAL_INITIALIZED ]] || [[ "$TERMINAL_INITIALIZED" == "false" ]]; then
        echo "[err][artist] terminal must be initialized before the artist"
        exit 1
    fi
    if $ARTIST_INITIALIZED; then
        return
    fi
    export ARTIST_INITIALIZED=true
    if ! [[ -d $ROOT/artist/__data__/$ARTIST_FONT ]]; then
        print_err "no such artist font '$ARTIST_FONT'"
        exit 1
    fi
    export SYMBOL_FILE="$ROOT/artist/__data__/$ARTIST_FONT/symbols.data"
    if ! [[ -f $SYMBOL_FILE ]]; then
        print_err "symbol file not available for artist font '$ARTIST_FONT'"
        exit 1
    fi
}

function __load_symbols__(){
    # Loads the `ALPHABET` array from the currently pointed `SYMBOL_FILE`.
    # Symbol details must be provided inside the METADATA section.
    # Symbol definitions must start just after the METADATA section in the 
    #  incremental order of the ascii code
    # Since Bash currently does not support exporting arrays, symbols are loaded
    #  and kept locally for each subshell

    for line in $(sed -n '/#>METADATA_BEGIN/,/#>METADATA_END/p' "$SYMBOL_FILE"); do
        if [[ $line =~ ^#\>BLOCK_WIDTH=([0-9]*)$ ]]; then
            # actual_block_width = visible_width + 1 (for newline charactor)
            export block_width="$((${BASH_REMATCH[1]}+1))" 
        elif [[ $line =~ ^#\>SYMBOL_HEIGHT=([0-9]*)$ ]]; then
            export symbol_height="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^#\>START_ASCII=([0-9]*)$ ]]; then
            export start_ascii="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^#\>SYMBOL_COUNT=([0-9]*)$ ]]; then
            export symbol_count="${BASH_REMATCH[1]}"
        fi
    done
    if [[ -z $block_width ]] || [[ -z $symbol_height ]]|| [[ -z $start_ascii ]]|| [[ -z $symbol_count ]]; then
        print_err "invalid symbol file '$SYMBOL_FILE'"
        exit 1
    fi
    symbol_start_line=$(($(sed -n '/#>METADATA_END/=' "$SYMBOL_FILE") + 1))
    symbol_end_line=$(($(($symbol_count * $(($symbol_height+1))))+1))

    # Why incrementing symbol_height and sym_beg below?
    # > This is to ignore the symbol `WIDTH` metadata line present on top of each symbol
    for sym_beg in $(seq $symbol_start_line $(($symbol_height+1)) $symbol_end_line); do
        ALPHABET[$start_ascii]=$(sed -n "$(($sym_beg+1)),$(($sym_beg+$symbol_height))p" "$SYMBOL_FILE")
        ALPHABET_WIDTH[$start_ascii]=$(sed -n "${sym_beg}s/.*WIDTH=\([0-9]*\).*/\1/p" "$SYMBOL_FILE")
        start_ascii=$(($start_ascii+1))
    done
}

function __draw_ascii__(){
    # $*: ascii codes to be drawn
    # Actual drawing happens here by picking symbols from the `ALPHABET` array and 
    #  drawing them row by row.
    # This does not handle display-terminal width overflaws, 
    # User must properly handle the lengths considering current display-terminal size.

    if ! [[ -v ALPHABET[@] ]]; then
        __load_symbols__
    fi
    for row in $(seq 0 $(($symbol_height-1))); do
        for sym_ascii in $*; do
            for col in $(seq 0 $((${ALPHABET_WIDTH[$sym_ascii]}-1))); do
                index=$(($(($row * $block_width))+$col))
                symbol=${ALPHABET[$sym_ascii]}
                char="${symbol:$index:1}"
                echo -n "${char/\./ }"
            done
        done
        echo ""
    done
}

function __draw_text__(){
    # $1: text to be drawn
    # Convert the charactors into ascii codes and pass them as a list 
    #  of args to `__draw_ascii__` method

    for (( i=0; i<${#1}; i++)); do
        l[$i]=$(printf '%d\n' "'${1:i:1}")
    done
    __draw_ascii__ ${l[@]:0:${#1}}
}

# public functions
function draw_txt() {
    __print_clr__ "$TXT_CLR"
    __draw_text__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_txt "[art] $1"
    fi
}

function draw_inf() {
    __print_clr__ "$INF_CLR"
    __draw_text__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_inf "[art] $1"
    fi
}

function draw_wrn() {
    __print_clr__ "$WRN_CLR"
    __draw_text__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_wrn "[art] $1"
    fi
}

function draw_err() {
    __print_clr__ "$ERR_CLR"
    __draw_text__ "$1"
    __print_clr__ "$RST_CLR"
    if $ENABLE_LOGGING; then
        log_err "[art] $1"
    fi
}

# entry point
__init__
export -f __load_symbols__
export -f __draw_ascii__
export -f __draw_text__

export -f draw_txt
export -f draw_inf
export -f draw_wrn
export -f draw_err
