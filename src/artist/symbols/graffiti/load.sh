#!/usr/bin/env bash

function load_alpha(){
    # $1: symbol filename
    # $2: container array name
    letter_index=0
    for i in $(seq 1 6 151); do
        IFS=''
        read -rd '' "$2[$letter_index]" <<< $(sed -n "$i,$(($i+5))s/#/ /gp" $1)
        unset IFS
        letter_index=$(($letter_index+1))
    done
}

function display(){
    unset IFS
    for row in $(seq 0 13 65); do
        for cid in $(seq 1 ${#*}); do
            for col in $(seq 0 10); do
                index=$(($row+$col))
                echo -n "${!cid:$index:1}"
            done
        done
        echo ""
    done
}

load_alpha 'upper.data' 'upper_alphabet'
load_alpha 'lower.data' 'lower_alphabet'

display "${upper_alphabet[18]}" "${lower_alphabet[20]}" "${lower_alphabet[12]}" "${lower_alphabet[20]}" "${lower_alphabet[3]}" "${lower_alphabet[20]}"
