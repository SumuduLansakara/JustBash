#!/usr/bin/env bash

function __load_symbols__(){
    # $1: filename
    for line in $(sed -n '/#>METADATA_BEGIN/,/#>METADATA_END/p' $1); do
        if [[ $line =~ ^#\>BLOCK_WIDTH=([0-9]*)$ ]]; then
            block_width="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^#\>SYMBOL_HEIGHT=([0-9]*)$ ]]; then
            symbol_height="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^#\>START_ASCII=([0-9]*)$ ]]; then
            start_ascii="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^#\>SYMBOL_COUNT=([0-9]*)$ ]]; then
            symbol_count="${BASH_REMATCH[1]}"
        fi
    done
    if [[ -z $block_width ]] || [[ -z $symbol_height ]]|| [[ -z $start_ascii ]]|| [[ -z $symbol_count ]]; then
        echo "insufficient symbol file metadata"
    fi
    symbol_start_line=$(($(sed -n '/#>METADATA_END/=' $1) + 1))
    symbol_end_line=$(($(($symbol_count * $(($symbol_height+1))))+1))

    for sym_beg in $(seq $symbol_start_line $(($symbol_height+1)) $symbol_end_line); do
        ALPHABET[$start_ascii]=$(sed -n "$(($sym_beg+1)),$(($sym_beg+$symbol_height))p" $1)
        ALPHABET_WIDTH[$start_ascii]=$(sed -n "${sym_beg}s/.*WIDTH=\([0-9]*\).*/\1/p" $1)
        ALPHABET_BLOCK_WIDTH[$start_ascii]=$(($block_width+1))
        start_ascii=$(($start_ascii+1))
    done
}

function __draw_ascii__(){
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
function draw_text(){
    for (( i=0; i<${#1}; i++)); do
        l[$i]=$(printf '%d\n' "'${1:i:1}")
    done
    __draw_ascii__ ${l[@]:0:${#1}}
}

export -f __draw_ascii__
export -f draw_text

__load_symbols__ 'symbols/graffiti/symbols.data'

draw_text "abcdefghijklm"
draw_text "nopqrstuvwxyz"

draw_text "ABCDEFGHIJKLM"
draw_text "NOPQRSTUVWXYZ"

draw_text "0123456789"

draw_text "!@#$%^&*()"
