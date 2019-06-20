# Use this to display a progress bar for an action with a known number of sub actions
# e.g. copying a known number of files
disable_cursor
echo "[placeholder] this line gets re-written"
TOTAL_SUB_ACTIONS=21 # number of sub actions
set_color $INF_CLR
for (( i=0; i<=TOTAL_SUB_ACTIONS; i++ )); do
    clear_prev_line
    # do sub action i out of TOTAL_SUB_ACTIONS
    print_progress $i $TOTAL_SUB_ACTIONS 100
    echo
    sleep 0.1
done
set_color $RST_CLR
enable_cursor
