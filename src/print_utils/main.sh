function print_progress(){
    # $1: current progress value
    # $2: max progress value
    echo -n '['
    if [[ $1 -gt 0 ]]; then
        printf '#%.0s' $(seq 1 $1)
    fi
    if [[ $2 -gt $1 ]]; then
        printf -- '-%.0s' $(seq 1 $(($2 - $1)))
    fi
    echo -n ']'
}

export -f print_progress
