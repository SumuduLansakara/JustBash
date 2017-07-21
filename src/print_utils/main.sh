function print_progress(){
    # $1: current progress value
    # $2: max progress value
    # $3: progress width

    echo -n '['
    for j in $(seq 1 $3); do
        if [[ $(($1 * $3 / $2)) -lt $j ]]; then
            echo -n '-'
        else
            echo -n '#'
        fi
    done
    echo -n "] $(printf '%2s' $(($1 * 100 / $2)) %)"
}

export -f print_progress
