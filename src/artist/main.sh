# source dependent scripts
. $ROOT/artist/settings.sh
. $ROOT/artist/configs.sh

# private functions
function __init__(){
    if [[ -z $TERMINAL_INITIALIZED ]] || [[ "$TERMINAL_INITIALIZED" == "false" ]]; then
        echo "[err][artist] JustBash terminal must be initialized before the artist"
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

    if $USE_TPUT; then
        type tput &>/dev/null
        if [[ $? -ne 0 ]]; then
            print_err "tput not available"
            exit 1
        fi
    else
        if [[ $TERMINAL_WIDTH -eq 0 ]]; then
            print_err "Terminal width cannot be zero"
            exit 1
        fi
    fi
}

function __load_symbols__(){
    # Loads the `ALPHABET` array from the currently pointed `SYMBOL_FILE`.
    # Symbol details must be provided inside the METADATA section.
    # Symbol definitions must start just after the METADATA section in the 
    #  incremental order of the ASCII code
    # Since Bash currently does not support exporting arrays, symbols are loaded
    #  and kept locally for each sub-shell

    for line in $(sed -n '/#>METADATA_BEGIN/,/#>METADATA_END/p' "$SYMBOL_FILE"); do
        if [[ $line =~ ^#\>BLOCK_WIDTH=([0-9]*)$ ]]; then
            # actual_block_width = visible_width + 1 (for newline character)
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
    # $*: ASCII codes to be drawn
    # Actual drawing happens here by picking symbols from the `ALPHABET` array and 
    #  drawing them row by row.
    # This automatically detects terminal width if tput usage is enabled and tput
    #  is available. This function will automatically apply a line break when 
    #  word-arts are about to exceed the terminal width

    if ! [[ -v ALPHABET[@] ]]; then
        __load_symbols__
    fi
    if $USE_TPUT; then
        TERMINAL_WIDTH=$(tput cols)
    fi
    while [[ $# -gt 0 ]]; do
        word_art_length=0
        current_line_chars=0
        for row in $(seq 0 $(($symbol_height-1))); do
            current_row_chars=0
            for sym_ascii in $*; do
                if [[ $row == 0 ]]; then
                    word_art_length=$(($word_art_length + ${ALPHABET_WIDTH[$sym_ascii]}))
                    if [[ $word_art_length -gt $TERMINAL_WIDTH ]]; then
                        break
                    fi
                    current_line_chars=$((current_line_chars + 1))
                else
                    if [[ $current_row_chars -ge $current_line_chars ]]; then
                        break
                    fi
                    current_row_chars=$(($current_row_chars + 1))
                fi
                for col in $(seq 0 $((${ALPHABET_WIDTH[$sym_ascii]}-1))); do
                    index=$(($(($row * $block_width))+$col))
                    symbol=${ALPHABET[$sym_ascii]}
                    char="${symbol:$index:1}"
                    echo -n "${char/\./ }"
                done
            done
            echo ""
        done
        shift $current_line_chars
    done
}

function __draw_text__(){
    # $1: text to be drawn
    # Convert the characters into ASCII codes and pass them as a list 
    #  of arguments to `__draw_ascii__` method

    for (( i=0; i<${#1}; i++)); do
        l[$i]=$(printf '%d\n' "'${1:i:1}")
    done
    __draw_ascii__ ${l[@]:0:${#1}}
}

# public functions
function draw_txt() {
    set_color "$TXT_CLR"
    __draw_text__ "$1"
    set_color "$RST_CLR"
    if $ENABLE_TERM_LOGGING; then
        log_txt "[art] $1"
    fi
}

function draw_inf() {
    set_color "$INF_CLR"
    __draw_text__ "$1"
    set_color "$RST_CLR"
    if $ENABLE_TERM_LOGGING; then
        log_inf "[art] $1"
    fi
}

function draw_wrn() {
    set_color "$WRN_CLR"
    __draw_text__ "$1"
    set_color "$RST_CLR"
    if $ENABLE_TERM_LOGGING; then
        log_wrn "[art] $1"
    fi
}

function draw_err() {
    set_color "$ERR_CLR"
    __draw_text__ "$1"
    set_color "$RST_CLR"
    if $ENABLE_TERM_LOGGING; then
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
